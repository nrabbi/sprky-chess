class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    pieces.each do |piece|
      return true if can_capture?(pieces, destination) == false && (piece.position.equals?(destination) || piece.position.y == (destination.y - 1) && piece.position.x == destination.x && color == :white && pawn_unused? == true && (position.y - destination.y).abs > 1 || piece.position.y == (destination.y + 1) && piece.position.x == destination.x && color == :black && pawn_unused? == true && (position.y - destination.y).abs > 1)
    end

    false
  end

  def is_valid?(pieces, destination)
    return false if can_capture?(pieces, destination) == false && (inside_board_boundaries?(destination.x, destination.y) == false || color == :white && destination.y < position.y || color == :black && destination.y > position.y || destination.x != position.x || pawn_unused? == true && (position.y - destination.y).abs > 2)

    true
  end

  def can_capture?(pieces, destination)
    pieces.each do |piece|
      return true if piece.position.equals?(destination) && destination.y - position.y == 1 && (position.x - destination.x).abs == 1 && piece.color == :black && color == :white || piece.position.equals?(destination) && position.y - destination.y == 1 && (position.x - destination.x).abs == 1 && piece.color == :white && color == :black
    end

    false
  end

  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end

  private

  def pawn_unused?
    position.y == 1 && color == :white || position.y == 6 && color == :black ? (return true) : (return false)
  end

end
