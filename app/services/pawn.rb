class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    distance_check = (destination.y - position.y).abs
    position.y == 1 && color == :white || position.y == 6 && color == :black ? (pawn_unused = true) : (pawn_unused = false)

    pieces.each do |piece|
      return true if piece.position.equals?(destination)
      return true if piece.position.y == (destination.y - 1) && piece.position.x == destination.x && color == :white && pawn_unused == true
      return true if piece.position.y == (destination.y + 1) && piece.position.x == destination.x && color == :black && pawn_unused == true
    end

    false
  end

  def is_valid?(destination)
    return false if inside_board_boundaries?(destination.x, destination.y) == false || color == :white && destination.y < position.y || color == :black && destination.y > position.y || destination.x != position.x
    true
  end

=begin
  # this method will be moved to a different file
  def can_capture?(pieces, destination)
    pieces.each do |piece|
      return true if piece.position.equals?(destination) && (position.y - destination.y).abs == 1 && (position.x - destination.x).abs == 1 && piece.color != color
    end

    false
  end
=end

  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end
end
