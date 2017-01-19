require 'rspec'
require 'rails_helper'

RSpec.describe "Queen" do
  describe 'queen#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a queen and a square' do

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
      obstructor_piece = MyChessPiece.new(2, 5)
      pieces = [queen, obstructor_piece]
      queen.is_obstructed?(pieces, destination).should == true

      # MORE TEST CASES SHOULD BE ADDED

    end

    it 'should determine that there is nothing between a queen and a square' do

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
      pieces = [queen, MyChessPiece.new(3, 2), MyChessPiece.new(3, 4), MyChessPiece.new(6, 7)]

      queen.is_obstructed?(pieces, destination).should == false
    end
  end
end
