class Move < ApplicationRecord
  belongs_to :game
  validates :from, presence: true
  validates :to, presence: true

end
