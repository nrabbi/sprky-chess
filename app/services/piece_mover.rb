class MoveResolution
  attr_accessor :error_message
  attr_accessor :pieces

  def initialize
    @error_message = ""
    @pieces = nil
  end

  def ok?
    @error_message.empty?
  end
end

class PieceMover

  # move_to!(pieces: ChessPiece[], moves: Move[], from: integer, to: integer)
  # -------------------------------
  # Moves a ChessPiece to a destination Position if a move is valid and unobstructed
  # Captured pieces are moved off the board
  def self.move_to!(_pieces, _moves)
    result = MoveResolution.new

    from = Position.new_from_int(_moves.last.from)
    to = Position.new_from_int(_moves.last.to)

    # 1) get the current state of the board:
    #     move pieces, remove any captured pieces

    # the new Move is created via current_game.moves.new
    # so it keeps the link to this game and all its moves.
    # in order to check if the move is valid, it can't be applied here
    # and needs to be sliced off
    result.pieces = apply_moves(_pieces, _moves[0..-2])
    # after_move_pieces is an array with all the chess pieces

    # 2) find the chess piece being moved
    pieces = result.pieces.select { |piece| piece.position.equals?(from) }

    if pieces.count == 0
      # the piece might be captured, this is okay
      # result.error_message += "No piece found at #{from.to_chess_position}."
      return result
    elsif pieces.count > 1
      result.error_message += "Invalid number of chess pieces when moving: #{pieces.count}. Should be 1 piece."
      return result
    end
    thisChessPiece = pieces[0]

    # 3) check if this move is valid
    is_valid = thisChessPiece.is_valid?(to)

    # 4) check for obstruction
    is_obstructed = thisChessPiece.is_obstructed?(result.pieces, to)

    # 5)
    can_capture = thisChessPiece.can_capture?(result.pieces, to)

    if can_capture && is_valid && !is_obstructed
      capture_int = thisChessPiece.color == :black ? Position::BLACK_CAPTURE_INT : Position::WHITE_CAPTURE_INT
      captured_piece = result.pieces.select { |piece| piece.position.equals?(to) }[0]
      captured_piece.position = Position.new_from_int(capture_int)
    end

    unless is_valid
      result.error_message += 'Invalid move. The move is invalid for that piece, it is not allowed to move there. '
      result.error_message += "When moving from #{from.to_chess_position} to #{to.to_chess_position}."
    end

    if is_obstructed
      result.error_message += 'Invalid move. The piece is obstructed. '
      result.error_message += "When moving from #{from.to_chess_position} to #{to.to_chess_position}."
    end

    result
  end

  def self.apply_moves(_pieces, _moves)
    new_pieces = _pieces.map(&:dup)

    _moves.each do |move|
      # look up the piece to move, by matching from-coordinate
      # of this move to positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move_position_from(move))

      to_piece = find_piece_for_coordinate(new_pieces, move_position_to(move))

      if to_piece && this_piece.can_capture?(new_pieces, move_position_to(move))
        capture_int = to_piece.color == :black ? Position::BLACK_CAPTURE_INT : Position::WHITE_CAPTURE_INT
        to_piece.position = Position.new_from_int(capture_int)
      end
      unless this_piece.nil?
        # move piece to new position
        this_piece.position = move_position_to(move)
      end
    end

    new_pieces
  end

  private

  def self.move_position_from(move)
    Position.new_from_int(move.from)
  end

  def self.move_position_to(move)
    Position.new_from_int(move.to)
  end

  def self.find_piece_for_coordinate(pieces, coordinate)
    pieces.find { |p| p.position.x == coordinate.x && p.position.y == coordinate.y }
  end
end
