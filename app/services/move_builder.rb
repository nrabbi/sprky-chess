class MoveBuilder
  attr_accessor :to
  attr_reader :from

    # Coordinate: [x, y]

  def initialize(x, y)
    @from = Position.new(x,y)
    @to = Position.new(99, 99)
  end
end