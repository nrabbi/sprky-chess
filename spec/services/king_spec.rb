require 'rspec'
require 'rails_helper'

RSpec.describe "King" do
  describe 'king#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a king and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,D,0,0,0,0,0 --> Destination is occupied
      # 0,0,0,K,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      king = King.new(3, 3)
      obstructor_piece = ChessPiece.new(2, 4)
      pieces = [king, obstructor_piece]
      destination = Position.new(2, 4)
      expect(king.is_obstructed?(pieces, destination)).to eq true

    end

    it 'should determine that there is nothing between a king and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,K,x,0,0,0 --> Destination is occupied
      # 0,0,0,x,D,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      king = King.new(3, 3)
      destination = Position.new(4, 2)
      pieces = [king, ChessPiece.new(3, 2), ChessPiece.new(4, 3)]

      expect(king.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
