class Move < ApplicationRecord
  belongs_to :game

  # OLD STUFF
  # attr_accessor :to
  # attr_reader :from

  # def initialize(x, y)
  #   @from = Position.new(x, y)
  #   @to = Position.new(99, 99)
  # end

  before_save :set_position
  # TODO - get this to work with Position.new objects

  def set_position
    square_letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    split_from = self.from.split('')
    split_to = self.to.split('')
    self.from = Position.new(square_letters.find_index(split_from.first), (split_from.last.to_i - 1))
    self.to = Position.new(square_letters.find_index(split_to.first), (split_to.last.to_i - 1))
    save
  end
end

