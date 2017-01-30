class Queen < ChessPiece

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE

  end

  def html_icon
    @color == :white ? "&#9813;" : "&#9819;"
  end
end
