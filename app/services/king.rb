class King < ChessPiece

  def is_obstructed?(pieces, destination)
    # king can move 1 square in any direction

    return true unless inside_board_boundaries?(destination.x, destination.y)

    # i guess the first piece is always the king we want to move...
    king = pieces[0]

    # first check if the destination is 1 square away
    absX = (destination.x - king.position.x).abs
    absY = (destination.y - king.position.y).abs

    return true if absX > 1 || absY > 1

    # destination is only 1 square away. Check if it is occupied already.
    otherPieces = pieces.slice(1, pieces.count - 1)

    otherPieces.each do |piece|
      return true if (piece.position.x == destination.x) && (piece.position.y == destination.y)
    end

    false
  end
  def html_icon
    @color == :white ? "&#9812;" : "&#9818;"
  end

end
