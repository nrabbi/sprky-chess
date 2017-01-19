class Bishop < MyChessPiece

  def is_obstructed?(pieces, destination)
    # first determine what x and y direction destination is from piece
    destination_is_to_right = false
    destination_is_above = false

    if destination.x > self.position.x
      destination_is_to_right = true
    end

    if destination.y > self.position.y
      destination_is_above = true
    end

    # move along path to destination
    curr_x = self.position.x
    curr_y = self.position.y
    while true do
      if destination_is_to_right
        curr_x += 1
      else
        curr_x -= 1
      end

      if destination_is_above
        curr_y += 1
      else
        curr_y -= 1
      end

      # check
      if inside_board_boundaries?(curr_x, curr_y) && !at_destination?(curr_x, curr_y, destination)
        if square_occupied?(pieces, Position.new(curr_x, curr_y))
          return true
        end
      else
        # made it this far without detecting obstruction, so no obstruction
        return false
      end
    end

    false
  end

  private

  def square_occupied?(pieces, position)
    pieces.each do |piece|
      if piece.position.x == position.x && piece.position.y == position.y
        return true
      end
    end

    false
  end

  def at_destination?(x, y, destination)
    x == destination.x && y == destination.y
  end

end