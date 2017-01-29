class King < ChessPiece
  attr_reader :color

  def is_obstructed?(pieces, destination)
    # IMPLEMENT HERE
    
  end

  def html_icon
    @color == :white ? "&#9812;" : "&#9818;"
  end
end