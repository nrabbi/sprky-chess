class MovesController < ApplicationController

  before_action :current_game, only: [:index, :new, :create]

  def new
    @move = Move.new
  end

  def create
    @new_move = current_game.moves.new(from: from_position.to_integer, to: to_position.to_integer)
    this_game_players = [current_game.player_1_id, current_game.player_2_id]

    pieces = StartingPositions::STARTING_POSITIONS
    after_move_pieces = PieceMover.apply_moves(pieces, @game.moves.select(&:persisted?))

    # pick the one being moved for error checking below
    piece = piece_to_be_moved(after_move_pieces, @new_move)

    if current_player.nil?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "You must be signed in to play."
    elsif this_game_players.exclude? current_player.id
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "You must be a player in this game to make a move."
    elsif current_game.player_1_won? || current_game.player_2_won?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "The game is over."
    elsif !current_game.started?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "Sorry, this game hasn't started yet. Waiting for another player to join."
    elsif !correct_player_turn?
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "Hey, it's not your turn!"
    elsif current_player_color(@game) != piece.color.to_s.capitalize
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "You can only move your own pieces."
    elsif castling_move?
      # pick the two pieces to be moved for a castling move
      castle_pieces = pieces_to_be_castled(after_move_pieces, @new_move)
      if castle_pieces && pieces_unmoved?
        castle = Castler.new(castle_pieces, after_move_pieces)
        castle.call
        castle.results
        if castle.error_message.blank?
          # save one move in DB which will be rendered in moves list like "Castled A1 and E1"
          king_start = castle.results[0].position
          king_finish = castle.results[1].position
          rook_start = castle.results[2].position
          @new_move.from = king_start.to_integer
          @new_move.to = king_finish.to_integer
          @new_move.save(validate: false)
          after_save_pieces = PieceMover.apply_moves(pieces, @game.moves)
          check = PieceMover.is_in_check(opposite_color(piece.color), after_save_pieces) ? true : false
          ActionCable.server.broadcast "game-#{current_game.id}",
                                         event: 'MOVE_CREATED',
                                         player: current_player,
                                         color: current_player_color(current_game),
                                         move: @new_move,
                                         from_letter: from_position.to_chess_position,
                                         to_letter: to_position.to_chess_position,
                                         game: current_game,
                                         message: "King at #{king_start.to_chess_position} has been castled with Rook at #{rook_start.to_chess_position}.",
                                         check: check
        else
          ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "Unable to castle. #{castle.error_message}"
        end
      else
        ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'NOT_ALLOWED',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: "Unable to castle. Pieces have been moved before."
        # redirect_to game_board_path(@game), alert: "Unable to castle. Pieces have been moved before."
      end

    elsif @new_move.valid?
      if @new_move.save

        after_save_pieces = PieceMover.apply_moves(pieces, @game.moves.select(&:persisted?))

        check = PieceMover.is_in_check(opposite_color(piece.color), after_save_pieces) ? true : false
        checkmate = false
        if check
          #   Check end of game
          checkmate = PieceMover.is_in_check_mate(opposite_color(piece.color), after_save_pieces)
          if checkmate
            #   End game logic
            if current_player.id == current_game.player_1_id
            #   player 1 won
              current_game.player_1_won!
            else
            #   player 2 won
              current_game.player_2_won!
            end
          end
        end

        ActionCable.server.broadcast "game-#{current_game.id}",
                                     event: 'MOVE_CREATED',
                                     player: current_player,
                                     color: current_player_color(current_game),
                                     move: @new_move,
                                     from_letter: from_position.to_chess_position,
                                     to_letter: to_position.to_chess_position,
                                     game: current_game,
                                     message: "#{current_player_color(current_game)} has moved",
                                     check: check,
                                     checkmate: checkmate
      end
    else
      ActionCable.server.broadcast "game-#{current_game.id}",
                                   event: 'MOVE_INVALID',
                                   player: current_player,
                                   color: current_player_color(current_game),
                                   move: @new_move,
                                   from_letter: from_position.to_chess_position,
                                   to_letter: to_position.to_chess_position,
                                   game: current_game,
                                   message: @new_move.errors.full_messages
    end
  end

  def player_turn(current_game)
    current_game.moves.count.even? ? "White" : "Black"
  end

  def correct_player_turn?
    if player_turn(current_game) == current_game.player_1_color
      player_turn_id = current_game.player_1_id
    elsif player_turn(current_game) == current_game.player_2_color
      player_turn_id = current_game.player_2_id
    end
    player_turn_id == current_player.id ? true : false
  end

  private

  def move_params
    params.require(:move).permit(:from, :to, :promo, :game_id)
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

  def piece_to_be_moved(pieces, move)
    pieces.detect { |piece| piece.position.to_integer == move.from }
  end

  def pieces_to_be_castled(pieces, move)
    castlers = []
    castlers << pieces.detect { |piece| piece.position.to_integer == move.from }
    castlers << pieces.detect { |piece| piece.position.to_integer == move.to }
    [castlers[0].class, castlers[1].class].include?(Rook && King) ? castlers : false
  end

  def castling_move?
    Move.castling_moves.include?([@new_move.from, @new_move.to])
  end

  def pieces_unmoved?
    saved_moves = @game.moves.select(&:persisted?)
    prior = saved_moves.select { |move| (move.from == (@new_move.from || @new_move.to)) || (move.to == (@new_move.from || @new_move.to)) }
    return true if prior.empty?
    false
  end

  def opposite_color(color)
    return :black if color == :white
    :white
  end

end
