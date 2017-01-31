class Move < ApplicationRecord
  belongs_to :game

  # OLD STUFF
  # attr_accessor :to
  # attr_reader :from

  # def initialize(x, y)
  #   @from = Position.new(x, y)
  #   @to = Position.new(99, 99)
  # end

end

