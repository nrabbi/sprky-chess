class PieceMover

  def move_pieces(pieces, moves)
    moved_pieces = apply_moves(pieces, moves)
  end

  private

  def square_letters
    ["A", "B", "C", "D", "E", "F", "G", "H"]
  end

  def move_position_from(move)
    split_from = move.from.split('')
    Position.new(square_letters.find_index(split_from.first), (split_from.last.to_i - 1))
  end

  def move_position_to(move)
    split_to = move.to.split('')
    Position.new(square_letters.find_index(split_to.first), (split_to.last.to_i - 1))
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
      # binding.pry
      unless this_piece.nil?
        # move piece to new position
        this_piece.position = move_position_to(move)
      end
    end
    new_pieces
  end
end
