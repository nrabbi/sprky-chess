class Knight < ChessPiece

  def is_valid?(destination)
    m1 = 1
    m2 = 2

    # Check L-shape
    x_diff = (position.x - destination.x).abs
    y_diff = (position.y - destination.y).abs
    valid_l_move = (x_diff == m1 && y_diff == m2) || (x_diff == m2 && y_diff == m1)

    valid_l_move && inside_board_boundaries?(destination.x, destination.y) && !position.equals?(destination)
  end

  def is_obstructed?(pieces, destination)
    # Just check if destination is occupied
    pieces.each do |piece|
      return true if piece.position.equals?(destination)
    end

    false
  end

  def html_icon
    @color == :white ? "&#9816;" : "&#9822;"
  end
end
