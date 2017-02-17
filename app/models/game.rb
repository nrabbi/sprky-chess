class Game < ApplicationRecord

  validates :name, presence: true
  scope :available, -> { where(player_2_id: nil) }

  CREATED = 'created'
  STARTED = 'started'
  PLAYER_1_WON = 'player 1 won'
  PLAYER_2_WON = 'player 2 won'
  DRAW = 'draw'

  enum status: {
    created: CREATED,
    started: STARTED,
    player_1_won: PLAYER_1_WON,
    player_2_won: PLAYER_2_WON,
    draw: DRAW
  }

  has_many :moves, dependent: :destroy
end
