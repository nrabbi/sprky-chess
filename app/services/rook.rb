class Rook < ChessPiece

  def is_obstructed?(pieces, destination)
    # rook can move n squares in any direction

    return true if not inside_board_boundaries?(destination.x, destination.y)

    rook = self 

    cellsTouched = [ destination ]

    # determine which axis and in which direction the rook is moving
    n = 0
    if destination.x > rook.position.x
      n = destination.x - rook.position.x
    else 
      n = rook.position.x - destination.x
    end


    if n > 0
      # going along x axis


      # then determine all cells being touched when the rook would 
      # do this move


      # this is a little tricky: 
      # the rook itself is in the parameter "pieces". When comparing all the pieces 
      # with all touched cells, it can obstruct itself. 
      # n-1 combined with the +1 makes sure the rook's position is not in the 
      # array of touched cells, thus it can not obstruct itself.
      (n-1).times do |i|
        cellsTouched << Position.new(self.position.x+i+1, self.position.y)
      end
    else 
      # going along y axis

      # see above

      if destination.y > rook.position.y
        n = destination.y - rook.position.y
      else 
        n = rook.position.y - destination.y
      end	

      # see above
      (n-1).times do |i|
        cellsTouched << Position.new(self.position.x, self.position.y+i+1)
      end
    end

    pieces.each do |piece|
      cellsTouched.each do |position| 
        return true if piece.position.x == position.x and piece.position.y == position.y
      end
    end

    return false  
  end
end
