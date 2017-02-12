class Pawn < ChessPiece

  def is_obstructed?(pieces, destination)
    pieces.each do |piece|
      return true if
      can_capture?(pieces, destination) == false && (piece.position.equals?(destination) || obstruction_check_white(piece, destination) || obstruction_check_black(piece, destination))
    end

    false
  end

  def is_valid?(destination)
    return false if (inside_board_boundaries?(destination.x, destination.y) == false || invalid_backwards_move_check_white(destination) || invalid_backwards_move_check_black(destination) || invalid_non_vertical_movement_check(destination) || invalid_starting_movement_check(destination))

    true
  end

  def can_capture?(pieces, destination)
    pieces.each do |piece|
      return true if piece.position.equals?(destination) && piece.position.equals?(destination) && diagonal_capture_check_white(piece, destination) || diagonal_capture_check_black(piece, destination)
    end

    false
  end

  def html_icon
    @color == :white ? "&#9817;" : "&#9823;"
  end

  private

  # checks if there is the pawn is moved/used or not
  def pawn_moved?
    position.y == 1 && color == :white || position.y == 6 && color == :black ? (return true) : (return false)
  end

  # checks if there is a piece in between the pawn and the destination
  def obstruction_check_white(piece, destination)
    piece.position.y == (destination.y - 1) && piece.position.x == destination.x && color == :white && pawn_moved? == true && (position.y - destination.y).abs > 1
  end

  def obstruction_check_black(piece, destination)
    piece.position.y == (destination.y + 1) && piece.position.x == destination.x && color == :black && pawn_moved? == true && (position.y - destination.y).abs > 1
  end

  # checks for invalid backwards movement for pawns
  def invalid_backwards_move_check_white(destination)
    color == :white && destination.y < position.y
  end

  def invalid_backwards_move_check_black(destination)
    color == :black && destination.y > position.y
  end

  # checks if the movement is vertical only or not
  def invalid_non_vertical_movement_check(destination)
    destination.x != position.x
  end

  # checks if the pawn movment fromstarting position is valid or not
  def invalid_starting_movement_check(destination)
    pawn_moved? == true && (position.y - destination.y).abs > 2
  end

  # capture logic for pawns
  def diagonal_capture_check_white(piece, destination)
    destination.y - position.y == 1 && (position.x - destination.x).abs == 1 && piece.color == :black && color == :white
  end

  def diagonal_capture_check_black(piece, destination)
    position.y - destination.y == 1 && (position.x - destination.x).abs == 1 && piece.color == :white && color == :black
  end

end
