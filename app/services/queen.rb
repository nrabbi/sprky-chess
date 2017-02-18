class Queen < ChessPiece

  def is_obstructed?(pieces, destination)
    return true unless inside_board_boundaries?(destination.x, destination.y)

    # 1) Determine what direction we are moving
    difference_x = (position.x - destination.x).abs
    difference_y = (position.y - destination.y).abs
    valid_diagonal_move = (difference_x > 0 || difference_y > 0) && (difference_x == difference_y)

    cellsTouched = []

    if valid_diagonal_move
      # 2) collect all touched cells
      n = difference_x > difference_x ? difference_x : difference_y

      inc_x = (destination.x > position.x) ? 1 : -1
      inc_y = (destination.y > position.y) ? 1 : -1

      (n-1).times do |i|
          cellsTouched << Position.new(position.x + ((i+1)*inc_x), position.y + ((i+1)*inc_y))
      end
    else
      moving_along_x = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
      moving_along_y = (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0

      if moving_along_x && moving_along_y
        raise "Cant be moving along x- and y-axis"
      elsif moving_along_x

        # 2) collect all touched cells
        n = destination.x > position.x ? destination.x - position.x : position.x - destination.x

        inc = (destination.x > position.x) ? 1 : -1

        (n-1).times do |i|
          cellsTouched << Position.new(position.x + ((i+1)*inc), position.y)
        end

      elsif moving_along_y
        # 2) collect all touched cells
        n = destination.y > position.y ? destination.y - position.y : position.y - destination.y

        inc = (destination.y > position.y) ? 1 : -1

        (n-1).times do |i|
          cellsTouched << Position.new(position.x, position.y + ((i+1)*inc))
        end
      else
        false
      end
    end

    # 3) check all touched cells for pieces on them
    pieces.each do |piece|
      cellsTouched.each do |position|
        return true if (piece.position.x == position.x) && (piece.position.y == position.y)
      end

      # check for a piece at the destination separately: 
      # only pieces of the same color are an obstruction. Opposite
      # colored pieces can be captured.
      return true if (piece.position.x == destination.x) && (piece.position.y == destination.y) && (piece.color == self.color)
    end

    false
  end

  def is_valid?(destination)
    x_diff = (position.x - destination.x).abs
    y_diff = (position.y - destination.y).abs
    valid_diagonal_move = (x_diff == y_diff)

    x_only_move = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
    y_only_move = (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0

    moved = !position.equals?(destination)

    (valid_diagonal_move || x_only_move || y_only_move) && moved && inside_board_boundaries?(destination.x, destination.y)
  end

  def html_icon
    @color == :white ? "&#9813;" : "&#9819;"
  end
end
