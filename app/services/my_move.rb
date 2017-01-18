class MyMove
  attr_accessor :to
  attr_reader :from
    # Coordinate: [x, y]

  def initialize(x, y)
        @from = [x, y]
        @to = []
  end

  def call
  end  

  private

  def applyMoves(pieces, moves)
  end

end