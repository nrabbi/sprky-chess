class Knight < ChessPiece

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE
  end

  def html_icon
    @color == :white ? "&#9816;" : "&#9822;"
  end
end