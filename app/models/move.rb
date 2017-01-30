class Move < ApplicationRecord
  belongs_to :game
  after_initialize :set_position
  # TODO - get this to work with Position.new objects

  private 

  def set_position
    square_letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    split_from = self.from.split('')
    split_to = self.to.split('')
    # updating :from and :to -- change this to use Position.new
    self.from = [square_letters.find_index(split_from.first), (split_from.last.to_i - 1)]
    self.to = [square_letters.find_index(split_to.first), (split_to.last.to_i - 1)]
  end
end
