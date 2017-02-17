class Rook < ChessPiece

  def is_valid?(destination)
    x_only_move = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
    y_only_move = (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0

    (x_only_move || y_only_move) && inside_board_boundaries?(destination.x, destination.y)
  end

  def is_obstructed?(pieces, destination)
    # rook can move n squares in any direction

    return true unless inside_board_boundaries?(destination.x, destination.y)

    rook = self

    cellsTouched = []

    # determine which axis and in which direction the rook is moving
    moving_along_x = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
    moving_along_y = (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0

    if moving_along_x && moving_along_y
      raise "Cant be moving along x- and y-axis"
    elsif moving_along_x

      # 2) collect all touched cells
      n = destination.x > position.x ? destination.x - position.x : position.x - destination.x

      inc = destination.x > position.x ? 1 : -1

      (n - 1).times do |i|
        cellsTouched << Position.new(position.x + ((i + 1) * inc), position.y)
      end

    elsif moving_along_y
      # 2) collect all touched cells
      n = destination.y > position.y ? destination.y - position.y : position.y - destination.y

      inc = destination.y > position.y ? 1 : -1

      (n - 1).times do |i|
        cellsTouched << Position.new(position.x, position.y + ((i + 1) * inc))
      end
    else
      raise "This rook is not moving anywhere, but should."
    end

    pieces.each do |piece|
      cellsTouched.each do |position|
        return true if (piece.position.x == position.x) && (piece.position.y == position.y)
      end
    end

    false
  end

  def html_icon
    @color == :white ? "&#9814;" : "&#9820;"
  end

end
