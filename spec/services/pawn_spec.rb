require 'rspec'
require 'rails_helper'

RSpec.describe "Pawn" do
  describe 'pawn#is_obstructed' do

    it 'makes sure diagonal capture move is not considered to be obstructed' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,D,0 --> Destination can be captured
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(5, 2))
      pieces = [pawn, ChessPiece.new(:black, Position.new(6, 3))]
      destination = Position.new(6, 3)
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end

    it 'determines that there is nothing between a pawn and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,D,0,0 --> Destination is unoccupied
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(5, 2))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(5, 3)
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end

    it 'determines that a piece is between a pawn and a square is obstructing the move' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0
      # 0,0,0,x,0,0,0,0 --> Destination obstructed
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(3, 1))
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 2))
      pieces = [pawn, obstructor_piece]
      destination = Position.new(3, 3)
      expect(pawn.is_obstructed?(pieces, destination)).to eq true

    end

  end

  describe 'pawn#is_valid?' do

    it 'determines that a valid move can be made if the pawn is not at starting position' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # D,0,0,0,0,0,0,0 --> Destination is invalid
      # 0,x,0,0,0,0,0,0
      # P,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(0, 2))
      pieces = [pawn, ChessPiece.new(:black, Position.new(1, 3))]
      destination = Position.new(0, 4)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn cant move out of bounds' do

      # 0,0,0,0,0,0,0,0 --> Destination is invalid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,P,0,0
      # 0,0,0,0,0,D,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(5, 3))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(5, 8)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn can move two blocks from starting position' do

      # 0,0,0,0,0,0,0,0
      # 0,P,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,D,0,0,0,0,0,0 --> Destination is valid
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(1, 6))
      pieces = [pawn, ChessPiece.new(:white, Position.new(2, 3))]
      destination = Position.new(1, 4)
      expect(pawn.is_valid?(destination)).to eq true

    end

    it 'determines that a pawn cannot move more than two blocks from starting position' do

      # 0,0,0,0,0,0,0,0
      # 0,P,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,D,x,0,0,0,0,0 --> Destination is invalid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(1, 6))
      pieces = [pawn, ChessPiece.new(:white, Position.new(2, 3))]
      destination = Position.new(1, 3)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn cant move backwards' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,D,0,0 --> Destination is invalid
      # 0,0,0,0,0,P,0,0
      # 0,x,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(5, 4))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(5, 5)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn cant move horizontally' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,D,P,0,0 --> Destination is invalid
      # 0,x,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(5, 4))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(4, 4)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn cannot move diagonally' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,D,0 --> Destination is invalid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(5, 4))
      pieces = [pawn, ChessPiece.new(:white, Position.new(6, 3))]
      destination = Position.new(6, 3)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn can move' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,D,0 --> Destination is invalid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(5, 4))
      pieces = [pawn, ChessPiece.new(:white, Position.new(6, 3))]
      destination = Position.new(5, 3)
      expect(pawn.is_valid?(destination)).to eq true

    end

  end

  describe 'pawn#can_capture?' do

    it 'determines that a pawn can capture diagonally' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,X,0,0,0 --> Destination capture valid
      # 0,0,0,0,P,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(4, 2))
      pieces = [pawn, ChessPiece.new(:black, Position.new(3, 3)), ChessPiece.new(:black, Position.new(4, 3))]
      destination = Position.new(3, 3)
      expect(pawn.can_capture?(pieces, destination)).to eq true

    end

    it 'determines that a pawn cannot capture diagonally if its more than one block away' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,D,0,0,0,0,0 --> Destination capture invalid
      # 0,0,0,0,X,0,0,0
      # 0,0,0,0,P,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(4, 2))
      pieces = [pawn, ChessPiece.new(:black, Position.new(2, 4)), ChessPiece.new(:black, Position.new(4, 3))]
      destination = Position.new(2, 4)
      expect(pawn.can_capture?(pieces, destination)).to eq false

    end

  end

end
