class Rook < ChessPiece

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE
  end

  def html_icon
    @color == :white ? "&#9814;" : "&#9820;"
  end
end