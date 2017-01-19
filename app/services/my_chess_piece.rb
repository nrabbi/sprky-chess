class MyChessPiece
  attr_accessor :type, :position

  def initialize(x, y)
    @type = 1
    @position = Position.new(x, y)
  end
end
