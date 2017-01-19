require 'rspec'
require 'rails_helper'

RSpec.describe "Knight" do
  describe 'knight#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a knight and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is occupied
      # 0,0,0,0,0,0,0,0
      # 0,0,K,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      knight = Knight.new(2, 2)
      destination = Position.new(3, 4)
      obstructor_piece = MyChessPiece.new(3, 4)
      pieces = [knight, obstructor_piece]
      knight.is_obstructed?(pieces, destination).should == true

    end

    it 'should determine that there is nothing between a knight and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,K,x,0,0,0,0
      # 0,0,x,x,0,0,0,0
      # 0,0,x,D,0,0,0,0 --> Destination is unoccupied
      # 0,0,0,0,0,x,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      knight = Knight.new(2, 4)
      destination = Position.new(3, 2)
      pieces = [knight, MyChessPiece.new(2, 2), MyChessPiece.new(2, 3), MyChessPiece.new(3, 3), MyChessPiece.new(3, 4),
                MyChessPiece.new(5, 1)]

      knight.is_obstructed?(pieces, destination).should == false
    end
  end
end
