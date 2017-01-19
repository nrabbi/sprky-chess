require 'rspec'
require 'rails_helper'

RSpec.describe "Pawn" do
  describe 'pawn#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a pawn and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is occupied
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(3, 3)
      obstructor_piece = MyChessPiece.new(3, 4)
      pieces = [pawn, obstructor_piece]
      destination = Position.new(3, 4)
      pawn.is_obstructed?(pieces, destination).should == true

    end

    it 'should determine that there is nothing between a pawn and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,0,0,0
      # 0,x,x,0,0,0,0,0
      # 0,0,x,D,x,0,0,0 --> Destination is unoccupied
      # 0,0,0,P,0,x,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      pawn = Pawn.new(3, 1)
      destination = Position.new(2, 3)
      pieces = [pawn, MyChessPiece.new(1, 3), MyChessPiece.new(1, 4), MyChessPiece.new(2, 2), MyChessPiece.new(2, 3),
                MyChessPiece.new(3, 3), MyChessPiece.new(4, 2), MyChessPiece.new(5, 1)]

      pawn.is_obstructed?(pieces, destination).should == false
    end
  end
end
