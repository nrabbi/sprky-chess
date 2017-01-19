require 'rspec'
require 'rails_helper'

RSpec.describe "Rook" do
  describe 'rook#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a rook and a square' do

      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,R,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      rook = Rook.new(2, 2)
      destination = Position.new(2, 7)
      obstructor_piece = MyChessPiece.new(2, 5)
      pieces = [rook, obstructor_piece]
      rook.is_obstructed?(pieces, destination).should == true

      # MORE TEST CASES SHOULD BE ADDED

    end

    it 'should determine that there is nothing between a rook and a square' do

      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,R,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      rook = Rook.new(2, 2)
      destination = Position.new(7, 7)
      pieces = [rook, MyChessPiece.new(2, 1), MyChessPiece.new(3, 4)]

      rook.is_obstructed?(pieces, destination).should == false
    end
  end
end
