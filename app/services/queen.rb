class Queen < ChessPiece

  def is_obstructed?(pieces, destination)
    return true unless inside_board_boundaries?(destination.x, destination.y)

    # 1) Determine what direction we are moving
    difference_x = (self.position.x - destination.x).abs
    difference_y = (self.position.y - destination.y).abs
    valid_diagonal_move = (difference_x > 0 || difference_y > 0) && (difference_x == difference_y)

    cellsTouched = [destination]

    if valid_diagonal_move
      # 2) collect all touched cells
      n = (difference_x > difference_x) ? difference_x : difference_y

      (n - 1).times do |i|
        cellsTouched << Position.new(position.x + i + 1, position.y + i + 1)
      end
    else
      moving_along_x = (self.position.x - destination.x).abs > 0 && (self.position.y - destination.y).abs == 0
      moving_along_y = (self.position.y - destination.y).abs > 0 && (self.position.x - destination.x).abs == 0

      if moving_along_x && moving_along_y
        raise "Cant be moving along x- and y-axis"
      elsif moving_along_x

        # 2) collect all touched cells
        n = (destination.x > self.position.x) ? destination.x - self.position.x : self.position.x - destination.x
        (n - 1).times do |i|
          cellsTouched << Position.new(position.x + i + 1, position.y)
        end

      elsif moving_along_y
        # 2) collect all touched cells
        n = (destination.y > self.position.y) ? destination.y - self.position.y : self.position.y - destination.y
        (n - 1).times do |i|
          cellsTouched << Position.new(position.x, position.y + i + 1)
        end
      else
        raise "This queen is not moving anywhere, but should."
      end
    end

    # 3) check all touched cells for pieces on them
    pieces.each do |piece|
      cellsTouched.each do |position|
        return true if (piece.position.x == position.x) && (piece.position.y == position.y) && piece.color == self.color
      end
    end

    false
  end

  def is_valid?(destination)
    x_diff = (self.position.x - destination.x).abs
    y_diff = (self.position.y - destination.y).abs
    valid_diagonal_move = (x_diff == y_diff)

    x_only_move = (self.position.x - destination.x).abs > 0 && (self.position.y - destination.y).abs == 0
    y_only_move = (self.position.y - destination.y).abs > 0 && (self.position.x - destination.x).abs == 0

    moved = !self.position.equals?(destination)

    (valid_diagonal_move || x_only_move || y_only_move) && moved && inside_board_boundaries?(destination.x, destination.y)
  end

  def html_icon
    @color == :white ? "&#9813;" : "&#9819;"
  end
end
