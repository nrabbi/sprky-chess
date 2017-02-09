class PieceMover

  def move_pieces(pieces, moves)
    moved_pieces = apply_moves(pieces, moves)
  end

  private

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
