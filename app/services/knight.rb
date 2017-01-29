class Knight < ChessPiece

  def is_obstructed?(pieces, destination)
    # Just check if destination is occupied
    pieces.each do |piece|
      return true if piece.position.equals?(destination)
    end

    false
  end
end
