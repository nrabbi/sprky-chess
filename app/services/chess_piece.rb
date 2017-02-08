class ChessPiece
  attr_accessor :position
  attr_reader :color

  BOARD_START = 0
  BOARD_END = 7
  BOARD_LENGTH = 8

  def initialize(color, position)
    @color = color
    @position = position
  end

  # Abstract Method(pieces : MyChessPiece[], destination: Position)
  # -------------------
  # Determines if another piece is between "self" and destination Position.
  # The pieces array will hold all 32 pieces, including self.
  def is_obstructed?(_pieces, _destination)
    raise NotImplementedError, "Must be able to detect obstruction!"
  end

  # Abstract Method(destination: Position)
  # -------------------
  # Determines if a destination is a valid move for a piece
  # A valid move is one that a chess piece can make based on it's ability.
  # For example: A rook moves vertically or sideways, a bishop diagonally etc.
  # This method doesn't handle obstruction
  def is_valid?(_destination)
    raise NotImplementedError, "Must be able to detect if a move is valid!"
  end

  def moved?(destination)
    !position.equals?(destination)
  end

  def valid_diagonal_move?(destination)
    x_diff = (position.x - destination.x).abs
    y_diff = (position.y - destination.y).abs
    (x_diff == y_diff)
  end

  def x_only_move?(destination)
    x_only_move = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
  end

  def y_only_move?(destination)
    (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0
  end

  private

  def inside_board_boundaries?(x, y)
    x <= BOARD_END && x >= BOARD_START && y <= BOARD_END && y >= BOARD_START
  end

  def at_destination?(x, y, destination)
    x == destination.x && y == destination.y
  end

end
