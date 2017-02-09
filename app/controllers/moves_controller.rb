class MovesController < ApplicationController
  def index
    set_game
  end

  def new
    set_game
    @move = Move.new
  end

  def create
    set_game

    # 1) extract arguments, all these are required as per move_params below
    from = Position.new_from_int(move_params[:from].to_i)
    to     = Position.new_from_int(move_params[:to].to_i)


    # 2) get the current state of the board.
    pieces = StartingPositions::STARTING_POSITIONS
    piece_mover = PieceMover.new
    after_move_pieces = piece_mover.move_pieces(pieces, @game.moves)
    # after_move_pieces is an array with all the chess pieces

    # 3) find the chess piece being moved
    pieces = after_move_pieces.select { |piece| piece.position.equals?(from)}
    if pieces.count != 1
      raise "Invalid number of chess pieces when moving: #{pieces.count}. Should be 1 piece."
    end
    thisChessPiece = pieces[0]

    # 4) check if this move is valid
    is_valid = thisChessPiece.is_valid?(to)
    is_obstructed = thisChessPiece.is_obstructed?(after_move_pieces, to)


    if is_valid && !is_obstructed
      @move = @game.moves.create(move_params)
      if @move.valid?
        redirect_to game_board_path(@game)
      else
        render :new, status: :unprocessable_entity
      end
    else
      message = 'Invalid move. '
      if is_obstructed
        message += 'The piece is obstructed. '
      end
      if !is_valid
        message += 'The move is invalid for that piece, it is not allowed to move there. '
      end
      message += "Moving from #{from.to_chess_position} to #{to.to_chess_position}."
      redirect_to game_board_path(@game), notice: message
    end
  end

  private

  def move_params
    params.require(:move).permit(:from, :to)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

end
