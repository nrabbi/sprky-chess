class MovesValidator < ActiveModel::Validator
    def validate(record)
        move_resolution = PieceMover.move_pieces(record.game.moves, record.from, record.to)
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

  validates_with MovesValidator

end
