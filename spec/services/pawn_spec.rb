require 'rspec'
require 'rails_helper'

RSpec.describe "Pawn" do
  describe 'pawn#is_obstructed' do

    it 'determines that there is nothing between a pawn and a square (Player 1)' do

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

    it 'determines that a piece already exists on the destination (Player 1)' do

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

    it 'determines that a piece is between a pawn and a square if the pawn moves two blocks (Player 1)' do

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

    it 'determines that a pawn can move two blocks if it is at starting position (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,X,0,D,0,0,0,0 --> Destination unoccupied
      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(3, 1))
      destination = Position.new(3, 3)
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      expect(pawn.is_obstructed?(pieces, destination)).to eq false

    end

    it 'determines that there is nothing between a pawn and a square (Player 2)' do

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

    it 'determines that a piece already exists on the destination (Player 2)' do

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
    it 'determines that a piece is between a pawn and a square if the pawn moves two blocks (Player 2)' do

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
    it 'determines that a pawn can move two blocks if it is at starting position (Player 2)' do

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

    it 'determines a piece of opposite color at the destination is not an obstruction' do
      pawn = Pawn.new(:white, Position.new(5, 0))
      destination = Position.new(6, 1)
      pieces = [pawn, ChessPiece.new(:black, destination)]

      expect(pawn.is_obstructed?(pieces, destination)).to eq false
    end

  end

  describe 'pawn#is_valid?' do

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

    it 'determines that a pawn cant move backwards (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,P,0,0
      # 0,0,0,0,0,D,0,0 --> Destination is invalid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(5, 3))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(5, 2)
      expect(pawn.is_valid?(destination)).to eq false

    end

    it 'determines that a pawn can move (Player 1)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,D,0,0 --> Destination is valid
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:white, Position.new(5, 2))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(5, 3)
      expect(pawn.is_valid?(destination)).to eq true

    end

    it 'determines that a pawn cant move backwards (Player 2)' do

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

    it 'determines that a pawn can move (Player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,x,0,0,0,P,0,0
      # 0,0,0,0,0,D,0,0 --> Destination is valid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(5, 3))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(5, 2)
      expect(pawn.is_valid?(destination)).to eq true

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

    it 'determines that a pawn cant move diagonally' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,P,0,0
      # 0,x,0,0,0,0,D,0 --> Destination is invalid
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(5, 4))
      pieces = [pawn, ChessPiece.new(:white, Position.new(1, 3))]
      destination = Position.new(6, 3)
      expect(pawn.is_valid?(destination)).to eq false

    end

  end

  # The tests will be moved to a different file
  describe 'pawn#can_capture?' do

    it 'determines that a pawn can capture diagonally (player 1)' do

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

    it 'determines that a pawn cannot capture diagonally if its more than one block away (player 1)' do

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

    it 'determines that a pawn can capture diagonally (player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,P
      # 0,0,0,0,0,0,D,0 --> Destination capture valid
      # 0,0,0,X,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(7, 6))
      pieces = [pawn, ChessPiece.new(:black, Position.new(3, 4)), ChessPiece.new(:white, Position.new(6, 5))]
      destination = Position.new(6, 5)
      expect(pawn.can_capture?(pieces, destination)).to eq true

    end

    it 'determines that a pawn cannot capture diagonally if its more than one block away (player 2)' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,P
      # 0,0,0,0,0,0,0,0 --> Destination capture invalid
      # 0,0,0,X,0,D,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      pawn = Pawn.new(:black, Position.new(7, 6))
      pieces = [pawn, ChessPiece.new(:black, Position.new(3, 4)), ChessPiece.new(:white, Position.new(5, 4))]
      destination = Position.new(5, 4)
      expect(pawn.can_capture?(pieces, destination)).to eq false

    end

  end

end
