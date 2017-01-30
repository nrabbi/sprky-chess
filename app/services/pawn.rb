class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    return true unless inside_board_boundaries?(destination.x, destination.y)
    destination.y > position.y ? (active_player = 1) : (active_player = 2)
    distance_check = (destination.y - position.y).abs

    if position.y == 1 && active_player == 1 || position.y == 6 && active_player == 2
      return true if distance_check > 2
      pawn_unused = true
    else
      return true if distance_check > 1
      pawn_unused = false
    end

    pieces.each do |piece|
      return true if piece.position.equals?(destination)
      return true if piece.position.y == (destination.y - 1) && piece.position.x == destination.x && active_player == 1 && pawn_unused == true
      return true if piece.position.y == (destination.y + 1) && piece.position.x == destination.x && active_player == 2 && pawn_unused == true
    end

    false
  end
  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end
end

