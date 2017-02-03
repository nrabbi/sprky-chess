class Position
  attr_accessor :x, :y

  CAPTURE_X = 0
  BLACK_CAPTURE_Y = ChessPiece::BOARD_START - 1
  WHITE_CAPTURE_Y = ChessPiece::BOARD_END + 1
  BLACK_CAPTURE_INT = -1
  WHITE_CAPTURE_INT = 64

  # 64(white capture)
  # -----------------------
  # 56,57,58,59,60,61,62,63
  # 48,49,50,51,52,53,54,55
  # 40,41,42,43,44,45,46,47
  # 32,33,34,35,36,37,38,39
  # 24,25,26,27,28,29,30,31
  # 16,17,18,19,20,21,22,23
  #  8, 9,10,11,12,13,14,15
  #  0, 1, 2, 3, 4, 5, 6, 7
  # -----------------------
  # -1(black capture)

  def initialize(x, y)
    @x = x
    @y = y
  end

  # Creates and returns Position using integer coordinate
  # Params:
  # +index: board position from BLACK_CAPTURE_INT to WHITE_CAPTURE_INT
  def self.new_from_int(index)
    if index > WHITE_CAPTURE_INT || index < BLACK_CAPTURE_INT
      raise ArgumentError, 'Integer position is out of bounds'
    end

    case index
    when BLACK_CAPTURE_INT
      x = CAPTURE_X
      y = BLACK_CAPTURE_Y
    when WHITE_CAPTURE_INT
      x = CAPTURE_X
      y = WHITE_CAPTURE_Y
    else
      x = index % 8
      y = index / 8
    end

    new(x, y)
  end

  # Compares two positions and returns true if they are the same
  # Params:
  # +position:: Position to be compared to
  def equals?(position)
    @x == position.x && @y == position.y
  end

  # Converts 2d array index(x,y) to 1d index(integer) and returns it
  def to_integer
    case @y
    when BLACK_CAPTURE_Y
      BLACK_CAPTURE_INT
    when WHITE_CAPTURE_Y
      WHITE_CAPTURE_INT
    else
      (@y * ChessPiece::BOARD_LENGTH) + @x
    end
  end
end
