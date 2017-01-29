require 'rspec'
require 'rails_helper'

RSpec.describe "Knight" do
  describe 'knight#is_obstructed' do # Assuming move is valid

    it 'determines that a piece is between a knight and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is occupied
      # 0,0,0,0,0,0,0,0
      # 0,0,K,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      knight = Knight.new(:white, Position.new(2, 2))
      destination = Position.new(3, 4)
      obstructor_piece = Pawn.new(:white, Position.new(3, 4))
      pieces = [knight, obstructor_piece]
      expect(knight.is_obstructed?(pieces, destination)).to eq true

    end

    it 'determines that there is nothing between a knight and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,K,x,0,0,0,0
      # 0,0,x,x,0,0,0,0
      # 0,0,x,D,0,0,0,0 --> Destination is unoccupied
      # 0,0,0,0,0,x,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      knight = Knight.new(:white, Position.new(2, 4))
      destination = Position.new(3, 2)
      pieces = [knight, Pawn.new(:white, Position.new(2, 2)), Pawn.new(:white, Position.new(2, 3)), Pawn.new(:white, Position.new(3, 3)), Pawn.new(:white, Position.new(3, 4)),
                Pawn.new(:white, Position.new(5, 1))]

      expect(knight.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
