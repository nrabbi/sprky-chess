class Bishop < ChessPiece

  def is_valid?(destination)
    valid_diagonal_move(destination) && moved(destination) && inside_board_boundaries?(destination.x, destination.y)
  end

  def is_obstructed?(pieces, destination)
    touched_cells = []
    curr_x = position.x
    curr_y = position.y
    case x_diff(destination) > 0
    when y_diff(destination) > 0
      (0..x_diff(destination)).each do
        touched_cells << Position.new(curr_x, curr_y)
        curr_x += 1
        curr_y += 1
      end
    when y_diff(destination) < 0
      (0..x_diff(destination)).each do
        touched_cells << Position.new(curr_x, curr_y)
        curr_x += 1
        curr_y -= 1
      end
    end

    case x_diff(destination) < 0
    when y_diff(destination) > 0
      (x_diff(destination)..0).each do
        touched_cells << Position.new(curr_x, curr_y)
        curr_x -= 1
        curr_y += 1
      end
    when y_diff(destination) < 0
      (x_diff(destination)..0).each do
        touched_cells << Position.new(curr_x, curr_y)
        curr_x -= 1
        curr_y -= 1
      end
    end

    # Don't test the starting square
    touched_cells.shift
    # Test the landing square separately in case of capture
    landing_sq = touched_cells.pop

    if touched_cells.any?
      pieces.each do |piece|
        touched_cells.each do |position|
          return true if piece_at_square(piece, position)
        end
      end
      false
    end
    pieces.each do |piece|
      return true if piece_at_square(piece, landing_sq) && (piece.color == color)
    end
    false
  end

  def html_icon
    @color == :white ? "&#9815;" : "&#9821;"
  end

  private

  def to_right?(destination)
    destination.x > position.x ? true : false
  end

  def above?(destination)
    destination.y > position.y ? true : false
  end

  def x_diff(destination)
    destination.x - position.x
  end

  def y_diff(destination)
    destination.y - position.y
  end

  def piece_at_square(piece, position)
    (piece.position.x == position.x) && (piece.position.y == position.y)
  end

  def valid_diagonal_move(destination)
    (x_diff(destination).abs == y_diff(destination).abs)
  end
  
  def moved(destination)
    !position.equals?(destination)
  end

end
