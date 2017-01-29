require 'rspec'
require 'rails_helper'

RSpec.describe "Queen" do
  describe 'queen#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a queen and a square' do
      pending("Queen is_obstructed? method is awaiting implementation")
      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,Q,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      queen = Queen.new(2, 2)
      destination = Position.new(2, 7)
      obstructor_piece = ChessPiece.new(2, 5)
      pieces = [queen, obstructor_piece]
      expect(queen.is_obstructed?(pieces, destination)).to eq true

      # MORE TEST CASES SHOULD BE ADDED

    end

    it 'should determine that there is nothing between a queen and a square' do
      pending("Queen is_obstructed? method is awaiting implementation")
      # 0,0,0,0,0,0,x,D
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,Q,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      queen = Queen.new(2, 2)
      destination = Position.new(7, 7)
      pieces = [queen, ChessPiece.new(3, 2), ChessPiece.new(3, 4), ChessPiece.new(6, 7)]

      expect(queen.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
