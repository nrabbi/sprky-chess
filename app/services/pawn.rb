class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    return true unless inside_board_boundaries?(destination.x, destination.y)
    destination.y > self.position.y ? (activePlayer = 1) : (activePlayer = 2)
    distanceCheck = (destination.y - self.position.y).abs

    if self.position.y == 1 && activePlayer == 1 or self.position.y == 6 && activePlayer == 2
      return true if distanceCheck > 2
      pawnAtStartingPosition = true
    else
      return true if distanceCheck > 1
      pawnAtStartingPosition = false
    end

    pieces.each do |piece|
      return true if piece.position.equals?(destination)
      return true if piece.position.y == (destination.y - 1) && piece.position.x == destination.x && activePlayer == 1 && pawnAtStartingPosition == true
      return true if piece.position.y == (destination.y + 1) && piece.position.x == destination.x && activePlayer == 2 && pawnAtStartingPosition == true
    end

    return false
  end
end