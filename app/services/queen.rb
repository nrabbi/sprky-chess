class Queen < ChessPiece

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE

  end

  def is_valid?(destination)
    x_diff = (self.position.x - destination.x).abs
    y_diff = (self.position.y - destination.y).abs
    valid_diagonal_move = (x_diff == y_diff)

    x_only_move = (self.position.x - destination.x).abs > 0 && (self.position.y - destination.y).abs == 0
    y_only_move = (self.position.y - destination.y).abs > 0 && (self.position.x - destination.x).abs == 0

    # moved = !self.position.equals?(destination)

    (valid_diagonal_move || x_only_move || y_only_move) && moved?(destination) && inside_board_boundaries?(destination.x, destination.y)
  end

  def html_icon
    @color == :white ? "&#9813;" : "&#9819;"
  end
end
