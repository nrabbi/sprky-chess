class MovesValidator < ActiveModel::Validator
  def validate(record)
    move_resolution = PieceMover.move_to!(StartingPositions::STARTING_POSITIONS, record.game.moves, record.from, record.to)
    unless move_resolution.ok?
      record.errors[:base] << move_resolution.error_message
    end
    move_resolution.ok?
  end
end

class Move < ApplicationRecord
  belongs_to :game
  validates :from, presence: true
  validates :to, presence: true
  validates_inclusion_of :from, in: (Position::BLACK_CAPTURE_INT..Position::WHITE_CAPTURE_INT)
  validates_inclusion_of :to, in: (Position::BLACK_CAPTURE_INT..Position::WHITE_CAPTURE_INT)

  validates_with MovesValidator

end
