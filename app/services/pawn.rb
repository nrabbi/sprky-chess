class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE

  end

  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end
end