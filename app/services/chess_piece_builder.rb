class ChessPieceBuilder
  attr_accessor :type, :position

  def initialize
    @type = 1
    @position = [99, 99]
  end
end