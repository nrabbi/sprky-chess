class Queen < ChessPiece

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE

  end

  def is_valid?(destination)
    x_only_move = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
    y_only_move = (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0

    (valid_diagonal_move?(destination) || x_only_move || y_only_move) && moved?(destination) && inside_board_boundaries?(destination.x, destination.y)
  end

  def html_icon
    @color == :white ? "&#9813;" : "&#9819;"
  end
end
