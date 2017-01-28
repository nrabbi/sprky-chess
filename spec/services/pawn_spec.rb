require 'rspec'
require 'rails_helper'

RSpec.describe "Pawn" do
  describe 'pawn#is_obstructed' do

    it 'should determine that there is nothing between a pawn and a square (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,D,0,0 --> Destination is unoccupied
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(5,2))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1,3))]
      destination = Position.new(5, 3)
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end


    it 'should determine that a piece already exists on the destination (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is occupied
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(3, 3))
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 4))
      pieces = [pawn, obstructor_piece]
      destination = Position.new(3, 4)
      expect(pawn.is_obstructed?(pieces, destination)).to eq true

    end

    # a pawn can move two blocks if it is at it's starting position
    it 'should determine that a piece is between a pawn and a square if the pawn moves two blocks (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0
      # 0,0,0,x,0,0,0,0 --> Destination path is obstructed
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(3, 1))
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 2))
      pieces = [pawn, obstructor_piece]
      destination = Position.new(3, 3)
      expect(pawn.is_obstructed?(pieces, destination)).to eq true

    end

    # a pawn can move two blocks if it is at it's starting position
    it 'should determine that a pawn can move two blocks if it is at starting position (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,X,0,D,0,0,0,0 --> Destination path is unoccupied
      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(3, 1))
      destination = Position.new(3, 3)
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end

    it 'should determine that there is nothing between a pawn and a square (Player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is unoccupied
      # 0,x,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(3, 5))
      destination = Position.new(3, 4)
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end

    it 'should determine that a piece already exists on the destination (Player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is occupied
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(3, 4))
      obstructor_piece = ChessPiece.new(:black, Position.new(3, 3))
      pieces = [pawn, obstructor_piece]
      destination = Position.new(3, 3)
      expect(pawn.is_obstructed?(pieces, destination)).to eq true

    end

    # a pawn can move two blocks if it is at it's starting position
    it 'should determine that a piece is between a pawn and a square if the pawn moves two blocks (Player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,0,x,0,0,0,0 --> Destination path is obstructed
      # 0,0,0,D,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(3, 6))
      obstructor_piece = ChessPiece.new(:black, Position.new(3, 5))
      pieces = [pawn, obstructor_piece]
      destination = Position.new(3, 4)
      expect(pawn.is_obstructed?(pieces, destination)).to eq true

    end

    # a pawn can move two blocks if it is at it's starting position
    it 'should determine that a pawn can move two blocks if it is at starting position (Player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination path unoccupied
      # 0,x,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(3, 6))
      destination = Position.new(3, 4)
      pieces = [pawn, ChessPiece.new(:black, Position.new(1, 3))]
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end

  end
end
