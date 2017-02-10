class MoveResolution
    attr_accessor :error_message
    def initialize
      @error_message = ""
    end
    def ok?
      @error_message.length == 0
    end
end

class PieceMover

  def move_position_from(move)
    Position.new_from_int(move.from)
  end

  def move_position_to(move)
    Position.new_from_int(move.to)
  end

  def find_piece_for_coordinate(pieces, coordinate)
    pieces.find { |p| p.position.x == coordinate.x && p.position.y == coordinate.y }
  end

  def self.move_pieces(moves, from, to)
    result = MoveResolution.new

    from = Position.new_from_int(from)
    to = Position.new_from_int(to)

    # 1) get the current state of the board.
    pieces = StartingPositions::STARTING_POSITIONS
    piece_mover = PieceMover.new

    # the new Move is created via current_game.moves.new
    # so it keeps the link to this game and all its moves.
    # in order to check if the move is valid, it can't be applied here
    # and needs to be sliced off
    after_move_pieces = piece_mover.apply_moves(pieces, moves[0..-2])
    # after_move_pieces is an array with all the chess pieces

    # 2) find the chess piece being moved
    pieces = after_move_pieces.select { |piece| piece.position.equals?(from)}

    if pieces.count == 0
      result.error_message += "No piece found at #{from.to_chess_position}"
      return result
    elsif pieces.count > 1
      result.error_message +=  "Invalid number of chess pieces when moving: #{pieces.count}. Should be 1 piece."
      return result
    end
    thisChessPiece = pieces[0]

    # 3) check if this move is valid
    is_valid = thisChessPiece.is_valid?(to)
    is_obstructed = thisChessPiece.is_obstructed?(after_move_pieces, to)

    if is_obstructed
      result.error_message += 'Invalid move. The piece is obstructed. '
      result.error_message += "Moving from #{from.to_chess_position} to #{to.to_chess_position}."
    end
    if !is_valid
      result.error_message += 'Invalid move. The move is invalid for that piece, it is not allowed to move there. '
      result.error_message += "Moving from #{from.to_chess_position} to #{to.to_chess_position}."
    end

    return result
  end

  def apply_moves(pieces, moves)
    new_pieces = pieces.map(&:dup)

    moves.each do |move|
      # look up the piece to move, by matching from-coordinate
      #  of this move to positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move_position_from(move))
      unless this_piece.nil?
        # move piece to new position
        this_piece.position = move_position_to(move)
      end
    end
    new_pieces
  end
end
