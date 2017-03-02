class MovesValidator < ActiveModel::Validator
  def validate(record)
    move_resolution = PieceMover.move_to!(StartingPositions::STARTING_POSITIONS,
                                                                      record.game.moves)
    unless move_resolution.ok?
      record.errors[:base] << move_resolution.error_message
    end
    move_resolution.ok?
  end
end

class Move < ApplicationRecord
  belongs_to :game

  default_scope { order(created_at: :asc) }

  validates :from, presence: true
  validates :to, presence: true
  validates_inclusion_of :from, in: (Position::BLACK_CAPTURE_INT..Position::WHITE_CAPTURE_INT)
  validates_inclusion_of :to, in: (Position::BLACK_CAPTURE_INT..Position::WHITE_CAPTURE_INT)

  validates_with MovesValidator

  def self.castling_moves
    coords = [[0, 4], [4, 7], [56, 60], [60, 63]]
    reversed = coords.map(&:reverse)
    reversed.each { |coord| coords << coord }
    coords
  end

end
