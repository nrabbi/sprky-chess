class PieceMover

  def move_pieces(pieces, moves)   
    moved_pieces = apply_moves(pieces, moves)
  end  

  private

  def find_piece_for_coordinate(pieces, coordinate)
    pieces.each do |p|
      if p.position.x == coordinate.x && p.position.y == coordinate.y
        return p
      else
        # TODO -- error for piece not found
      end
    end
  end

  def apply_moves(pieces, moves)
    new_pieces = pieces.map { |p| p.dup }

    moves.each do |move|
      # 1. look up the piece for this piece by matching the coordinate
      #     of this move by positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move.from)
      unless this_piece.nil?
        # 2. move piece to new position
        this_piece.position = move.to
      end
      # new_pieces has wrong values
    end
    return new_pieces
  end
end