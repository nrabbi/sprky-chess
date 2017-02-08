class Move < ApplicationRecord
  belongs_to :game
  validates :from, presence: true
  validates :to, presence: true
  validates_inclusion_of :from, in: (0..63)
  validates_inclusion_of :to, in: (0..63)

end
