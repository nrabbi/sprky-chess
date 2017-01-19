class MoveBuilder
  attr_accessor :to
  attr_reader :from

    # Coordinate: [x, y]

  def initialize(x, y)
    @from = [x, y]
    @to = []
  end
end