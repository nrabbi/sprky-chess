class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    pieces.each do |piece|
      return true if
      can_capture?(pieces, destination) == false && (piece.position.equals?(destination) || obstruction_check(piece, destination))
    end

    false
  end

  def is_valid?(destination)
    return false if invalid_non_starting_move_check(destination) || invalid_starting_move_check(destination) || !inside_board_boundaries?(destination.x, destination.y) || invalid_backwards_move_check(destination) || invalid_non_vertical_move_check(destination)

    true
  end

  def can_capture?(pieces, destination)
    pieces.each do |piece|
      return true if piece.position.equals?(destination) && diagonal_capture_check(piece, destination)
    end

    false
  end

  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end

  private

  # checks if the pawn is at least used once or not
  def pawn_not_moved?
    (position.y == 1 && color == :white) || (position.y == 6 && color == :black) ? (return true) : (return false)
  end

  # checks if there is a piece in between the pawn and the destination
  # checks for invalid diagonal movement
  def obstruction_check(piece, destination)
    return true if !piece.position.equals?(destination) &&  (destination.y - position.y == 1 && (position.x - destination.x).abs == 1 || position.y - destination.y == 1 && (position.x - destination.x).abs == 1)

    if color == :white
      piece.position.y == (destination.y - 1) && piece.position.x == destination.x && pawn_not_moved? && (position.y - destination.y).abs > 1
    else color == :black && piece != nil
      piece.position.y == (destination.y + 1) && piece.position.x == destination.x && pawn_not_moved? && (position.y - destination.y).abs > 1
    end

  end

  # checks for invalid backwards move for pawns
  def invalid_backwards_move_check(destination)
    color == :white ? (destination.y < position.y) : (destination.y > position.y)
  end

  # checks for non vertical invalid moves
  def invalid_non_vertical_move_check(destination)
    destination.x != position.x && (destination.y == position.y || (destination.y - position.y).abs > 1)
  end

  # checks if the pawn movement from starting position is valid or not
  def invalid_starting_move_check(destination)
    pawn_not_moved? && (position.y - destination.y).abs > 2
  end

  # checks if the pawn movement from non starting position is valid or not
  def invalid_non_starting_move_check(destination)
    pawn_not_moved? == false && (position.y - destination.y).abs > 1
  end

  # diagonal one block capture logic for pawns
  def diagonal_capture_check(piece, destination)
    if piece.color == :black && color == :white
      destination.y - position.y == 1 && (position.x - destination.x).abs == 1
    elsif piece.color == :white && color == :black
      position.y - destination.y == 1 && (position.x - destination.x).abs == 1
    end
  end

end
