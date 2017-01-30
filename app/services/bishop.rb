class Bishop < ChessPiece

  def is_obstructed?(pieces, destination)
    # first determine what x and y direction destination is from piece
    destination_is_to_right = false
    destination_is_above = false

    destination_is_to_right = true if destination.x > position.x

    destination_is_above = true if destination.y > position.y

    # move along path to destination
    curr_x = position.x
    curr_y = position.y
    loop do
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
        return true if square_occupied?(pieces, Position.new(curr_x, curr_y))
      else
        # made it this far without detecting obstruction, so no obstruction
        return false
      end
    end

    false
  end

  def html_icon
    @color == :white ? "&#9815;" : "&#9821;"
  end

  private

  def square_occupied?(pieces, position)
    pieces.each do |piece|
      return true if piece.position.equals?(position)
    end

    false
  end

end
