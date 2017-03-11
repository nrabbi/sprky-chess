class MovesController < ApplicationController

  before_action :current_game, only: [:index, :new, :create]

  def index; end

  def new
    @move = Move.new
  end

  def create
    new_move = current_game.moves.new(from: from_position.to_integer, to: to_position.to_integer)
    this_game_players = [ current_game.player_1_id, current_game.player_2_id ]

    pieces = StartingPositions::STARTING_POSITIONS
    after_move_pieces = PieceMover.apply_moves(pieces, @game.moves.select(&:persisted?))

    # pick the one being moved for error checking below
    piece = piece_to_be_moved(after_move_pieces, new_move)



    # TODO if the enemy player is in check, send a notification

    if current_player.nil?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "You must be signed in to play."
      # redirect_to game_board_path(@game), alert: "You must be signed in to play."
    elsif this_game_players.exclude? current_player.id
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "You must be a player in this game to make a move."
      # redirect_to game_board_path(@game), alert: "You must be a player in this game to make a move."
    elsif !current_game.started?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "Sorry, this game hasn't started yet. Waiting for another player to join."
      # redirect_to game_board_path(@game), alert: "Sorry, this game hasn't started yet. Waiting for another player to join."
    elsif !correct_player_turn?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "Hey, it's not your turn!"
      # redirect_to game_board_path(@game), alert: "Hey, it's not your turn!"
    elsif current_player_color(@game) != piece.color.to_s.capitalize
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "You can only move your own pieces."
      # redirect_to game_board_path(@game), alert: "You can only move your own pieces."
    elsif new_move.valid?
      if new_move.save
        after_save_pieces = PieceMover.apply_moves(pieces, @game.moves.select(&:persisted?))

        PieceMover::is_in_check(opposite_color(piece.color), after_save_pieces) ? check = true : check = false

        ActionCable.server.broadcast "game-#{current_game.id}",
                                     event: 'MOVE_CREATED',
                                     player: current_player,
                                     color: current_player_color(current_game),
                                     move: new_move,
                                     from_letter: from_position.to_chess_position,
                                     to_letter: to_position.to_chess_position,
                                     game: current_game,
                                     message: "#{current_player_color(current_game)} has moved",
                                     check: check
      end
    else
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'MOVE_INVALID',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: new_move.errors.full_messages
      # redirect_to game_board_path(@game), notice: @new_move.errors
    end
  end

  def player_turn(current_game)
    current_game.moves.count.even? ? "White" : "Black"
  end

  def correct_player_turn?
    if player_turn(current_game) == current_game.player_1_color
      player_turn_id = current_game.player_1_id
    else player_turn(current_game) == current_game.player_2_color
         player_turn_id = current_game.player_2_id
    end
    player_turn_id == current_player.id ? true : false
  end

  private

  def move_params
    params.require(:move).permit(:from, :to)
  end

  def current_game
    @game ||= Game.find(params[:game_id])
  end

  def from_position
    Position.new_from_int(move_params[:from].to_i)
  end

  def to_position
    Position.new_from_int(move_params[:to].to_i)
  end

  def current_player_color(current_game)
    if current_player && current_player.id == current_game.player_1_id
      current_game.player_1_color
    elsif current_player && current_player.id == current_game.player_2_id
      current_game.player_2_color
    end
  end

  def piece_to_be_moved(_pieces, _move)
    _pieces.detect{ |piece| piece.position.to_integer == _move.from }
  end


  def opposite_color(color)
    return :black if color == :white
    :white
  end

end
