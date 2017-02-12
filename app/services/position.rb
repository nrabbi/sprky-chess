class Position
  attr_accessor :x, :y

  CAPTURE_X = 0
  BLACK_CAPTURE_Y = ChessPiece::BOARD_START - 1
  WHITE_CAPTURE_Y = ChessPiece::BOARD_END + 1
  BLACK_CAPTURE_INT = -1
  WHITE_CAPTURE_INT = 64

    CHESS_POSITION_NAMES = [
      'A1','B1','C1','D1','E1','F1','G1','H1',
      'A2','B2','C2','D2','E2','F2','G2','H2',
      'A3','B3','C3','D3','E3','F3','G3','H3',
      'A4','B4','C4','D4','E4','F4','G4','H4',
      'A5','B5','C5','D5','E5','F5','G5','H5',
      'A6','B6','C6','D6','E6','F6','G6','H6',
      'A7','B7','C7','D7','E7','F7','G7','H7',
      'A8','B8','C8','D8','E8','F8','G8','H8'
  ]

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

    def to_chess_position
    index = to_integer
    if index == BLACK_CAPTURE_INT
      return 'Black Capture Area'
    elsif index == WHITE_CAPTURE_INT
      return 'White Capture Area'
    end
    return CHESS_POSITION_NAMES[index]
  end
end
