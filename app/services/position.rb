class Position
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
  
  # Compares two positions and returns true if they are the same
  # Params:
  # +position:: Position to be compared to
  def equals?(position)
    @x == position.x && @y == position.y
  end
end
