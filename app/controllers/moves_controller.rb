class MovesController < ApplicationController

  before_action :current_game, only: [:index, :new, :create]

  def index; end

  def new
    @move = Move.new
  end

  def create
    @new_move = current_game.moves.new(from: from_position.to_integer, to: to_position.to_integer)
    this_game_players = [ current_game.player_1_id, current_game.player_2_id ]

    pieces = StartingPositions::STARTING_POSITIONS
    after_move_pieces = PieceMover.apply_moves(pieces, @game.moves.select(&:persisted?))

    # pick the one being moved for error checking below
    piece = piece_to_be_moved(after_move_pieces, @new_move)

    # TODO if the enemy player is in check, send a notification
    # binding.pry
    if current_player.nil?
      redirect_to game_board_path(@game), alert: "You must be signed in to play."
    elsif this_game_players.exclude? current_player.id
      redirect_to game_board_path(@game), alert: "You must be a player in this game to make a move."
    elsif !current_game.started?
      redirect_to game_board_path(@game), alert: "Sorry, this game hasn't started yet. Waiting for another player to join."
    elsif !correct_player_turn?
      redirect_to game_board_path(@game), alert: "Hey, it's not your turn!"
    elsif current_player_color(@game) != piece.color.to_s.capitalize
      redirect_to game_board_path(@game), alert: "You can only move your own pieces."
    elsif castling_move?
      # pick the two pieces to be moved for a castling move
      castle_pieces = pieces_to_be_castled(after_move_pieces, @new_move)
      # binding.pry
      if pieces_unmoved?
        castle = Castler.new(castle_pieces, after_move_pieces).call
        if castle == true
          # pass new positions to @new_move
          @new_move.save(validate: false)
          redirect_to game_board_path(@game), notice: "King at #{@king.position} has been castled with Rook at #{@rook.position}."
        else
          # binding.pry
          redirect_to game_board_path(@game), alert: "Unable to castle. #{castle}"
        end
      end
    elsif @new_move.valid?
      @new_move.save

      redirect_to game_board_path(@game)
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

  def piece_to_be_moved(_pieces, _move)
    _pieces.detect{ |piece| piece.position.to_integer == _move.from }
  end

  def pieces_to_be_castled(pieces, move)
    castlers = []
    castlers << pieces.detect{ |piece| piece.position.to_integer == move.from }
    castlers << pieces.detect{ |piece| piece.position.to_integer == move.to }
  end

  def castling_move?
    Move.castling_moves.include?([@new_move.from, @new_move.to])
  end

  def pieces_unmoved?
    saved_moves = @game.moves.select(&:persisted?)
    prior = saved_moves.select { |move| move.from == (@new_move.from || @new_move.to) }
    return true if prior.empty?
    false
  end

end
