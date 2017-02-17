class King < ChessPiece

  def is_valid?(destination)
    distance_valid = ((position.x - destination.x).abs < 2) && ((position.y - destination.y).abs < 2) && !position.equals?(destination)

    inside_board_boundaries?(destination.x, destination.y) && distance_valid
  end

  def is_obstructed?(pieces, destination)
    # king can move 1 square in any direction

    return true unless inside_board_boundaries?(destination.x, destination.y)

    # first check if the destination is 1 square away
    absX = (destination.x - position.x).abs
    absY = (destination.y - position.y).abs

    return true if absX > 1 || absY > 1

    # destination is only 1 square away. Check if it is occupied already.
    otherPieces = pieces.slice(1, pieces.count - 1)

    otherPieces.each do |piece|
      return true if (piece.position.x == destination.x) && (piece.position.y == destination.y) && (piece.color == color)
    end

    false
  end

  def html_icon
    @color == :white ? "&#9812;" : "&#9818;"
  end

end
