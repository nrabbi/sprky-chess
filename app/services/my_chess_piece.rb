class MyChessPiece
  attr_accessor :type, :position
  BOARD_START = 0
  BOARD_END = 7

  def initialize(x, y)
    @type = 1
    @position = Position.new(x, y)
  end

  # Abstract Method(pieces : MyChessPiece[], destination: Position)
  # -------------------
  # Determines if another piece is between "self" and destination Position.
  # The pieces array will hold all 32 pieces, including self.
  def is_obstructed?(pieces, destination)
    fail NotImplementedError, "Must be able to detect obstruction!"
  end

  private
  def inside_board_boundaries?(x, y)
    x <= BOARD_END && x >= BOARD_START && y <= BOARD_END && y >= BOARD_START
  end
end
