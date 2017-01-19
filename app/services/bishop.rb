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
      puts curr_x.to_s + ',' +  curr_y.to_s
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

      if inside_board_boundaries?(curr_x, curr_y) && !at_destination?(curr_x, curr_y, destination)
        puts 'CHECKING SQUARE'
        if square_occupied?(pieces, Position.new(curr_x, curr_y))
          puts 'SQUARE OCCUPIED'
          return true
        end
      else
        if !inside_board_boundaries?(curr_x, curr_y)
          puts 'OUTSIDE BOUNDARIES'
        else
          puts 'AT DESTINATION(' + destination.x.to_s + ',' + destination.y.to_s + ')'
        end
        # made it this far without detecting obstruction, so no obstruction
        return false
      end
    end
    puts 'MADE IT TO END'
    false
  end

  private

  def square_occupied?(pieces, position)
    pieces.each do |piece|
      puts piece.position.x.to_s + ' vs ' + position.x.to_s
      if piece.position.x == position.x && piece.position.y == position.y
        puts 'OCCUPIED!'
        return true
      end
    end

    false
  end

  def inside_board_boundaries?(x, y)
    x < 8 && x > -1 && y < 8 && x > -1
  end

  def at_destination?(x, y, destination)
    x == destination.x && y == destination.y
  end
end