class Knight < ChessPiece

  def is_obstructed?(pieces, destination)
    # Just check if destination is occupied
    pieces.each do |piece|
      return true if piece.position.equals?(destination) && piece.color == self.color
    end

    false
  end

  def html_icon
    @color == :white ? "&#9816;" : "&#9822;"
  end
end
