class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    return true unless inside_board_boundaries?(destination.x, destination.y)
    distance_check = (destination.y - position.y).abs

    if position.y == 1 && color == :white || position.y == 6 && color == :black
      return true if distance_check > 2
      pawn_unused = true
    else
      return true if distance_check > 1
      pawn_unused = false
    end

    pieces.each do |piece|
      return true if piece.position.equals?(destination)
      return true if piece.position.y == (destination.y + 1) && piece.position.x == destination.x && color == :white && pawn_unused == true
      return true if piece.position.y == (destination.y - 1) && piece.position.x == destination.x && color == :black && pawn_unused == true
    end

    false
  end

  def is_valid?(destination)
    return false if color == :white && destination.y < position.y || color == :black && destination.y > position.y || destination.x != position.x
    true
  end

  def can_capture?(pieces, destination)
    pieces.each do |piece|
      return true if piece.position.equals?(destination) && (position.y - destination.y).abs == 1 && (position.x - destination.x).abs == 1 && piece.color != color
    end

    false
  end

  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end
end
