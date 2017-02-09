class PieceMover

  # move_to!(piece: ChessPiece, destination: Position, _pieces: ChessPiece[])
  # -------------------------------
  # Moves a ChessPiece to a destination Position if a move is valid and unobstructed
  # Obstruction is checked using the _pieces array
  # Captured pieces are moved off the board
  
  def move_to!(_chess_piece, _destination, _pieces)

     # if _chess_piece.can_capture? false
     #   Do something
     # else
     #   remove_piece(_destination)
     #   update_attributes(new_x,new_y)
     # end

  end

  def move_pieces(pieces, moves)
    moved_pieces = apply_moves(pieces, moves)
  end

  private

  # def square_letters
  #   ["A", "B", "C", "D", "E", "F", "G", "H"]
  # end

  def move_position_from(move)
    Position.new_from_int(move.from)
  end

  def move_position_to(move)
    Position.new_from_int(move.to)
  end

  def find_piece_for_coordinate(pieces, coordinate)
    pieces.find { |p| p.position.x == coordinate.x && p.position.y == coordinate.y }
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
