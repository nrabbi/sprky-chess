class Game < ApplicationRecord

  validates :name, presence: true

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

  has_many :moves

  def initialize
    @piece_mover = PieceMover.new
  end

  def move_pieces
    # do the moving here...
  end
end
