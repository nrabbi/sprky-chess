class MyChessPiece
  attr_accessor :type, :position
  BOARD_START = 0
  BOARD_END = 7

  def initialize(x, y)
    @type = 1
    @position = Position.new(x, y)
  end

  private
  def inside_board_boundaries?(x, y)
    x <= BOARD_END && x >= BOARD_START && y <= BOARD_END && y >= BOARD_START
  end
end
