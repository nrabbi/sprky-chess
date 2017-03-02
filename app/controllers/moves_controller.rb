class MovesController < ApplicationController

  before_action :current_game, only: [:index, :new, :create]

  def index; end

  def new
    @move = Move.new
  end

  def create
    @new_move = current_game.moves.new(from: from_position.to_integer, to: to_position.to_integer)
    this_game_players = [ current_game.player_1_id, current_game.player_2_id ]
    if current_player.nil?
      redirect_to game_board_path(@game), alert: "You must be signed in to play."
    elsif this_game_players.exclude? current_player.id
      redirect_to game_board_path(@game), alert: "You must be a player in this game to make a move."
    elsif !current_game.started?
      redirect_to game_board_path(@game), alert: "Sorry, this game hasn't started yet. Waiting for another player to join."
    elsif !correct_player_turn?
      redirect_to game_board_path(@game), alert: "Hey, it's not your turn!"
    elsif current_player_color(@game) != color_of_piece_to_be_moved
      redirect_to game_board_path(@game), alert: "You can only move your own pieces."
    elsif @new_move.valid?
      if @new_move.save
        ActionCable.server.broadcast "game-#{current_game.id}",
                                     event: 'MOVE_CREATED',
                                     player: current_player,
                                     color: current_player_color(current_game),
                                     move: @new_move,
                                     from_letter: from_position.to_chess_position,
                                     to_letter: to_position.to_chess_position,
                                     game: current_game,
                                     message: "#{current_player_color(current_game)} has moved"
      end
    else
      redirect_to game_board_path(@game), notice: @new_move.errors
    end
  end

  def player_turn(current_game)
    current_game.moves.count % 2 == 0 ? "White" : "Black"
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
    else
      # current_player is not playing this game or no current_player
      return
    end
  end
  def color_of_piece_to_be_moved
    pieces = StartingPositions::STARTING_POSITIONS
    saved_game_moves = @game.moves.select(&:persisted?)
    @after_move_pieces = PieceMover.apply_moves(pieces, saved_game_moves)
    @after_move_pieces.detect{ |piece| piece.position.to_integer == @new_move.from }.color.to_s.capitalize
  end

end
