class King < ChessPiece
  attr_reader :color


  def is_obstructed?(pieces, destination)
    # king can move 1 square in any direction

    return true if not inside_board_boundaries?(destination.x, destination.y)

    # i guess the first piece is always the king we want to move...
    king = pieces[0]

    # first check if the destination is 1 square away
    absX = (destination.x - king.position.x).abs
    absY = (destination.y - king.position.y).abs

    if absX > 1 or absY > 1
      return true
    end

    # destination is only 1 square away. Check if it is occupied already.
    otherPieces = pieces.slice(1, pieces.count - 1)

    otherPieces.each do |piece|
      return true if piece.position.x == destination.x and piece.position.y == destination.y
    end

    return false
  end
end