class Move < ApplicationRecord
  belongs_to :game
  validates :from, presence: true
  validates :to, presence: true
  validates_inclusion_of :from, in: (Position::BLACK_CAPTURE_INT..Position::WHITE_CAPTURE_INT)
  validates_inclusion_of :to, in: (Position::BLACK_CAPTURE_INT..Position::WHITE_CAPTURE_INT)

end
