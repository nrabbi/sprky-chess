require 'rspec'
require 'rails_helper'

describe 'PieceMover' do

  describe 'PieceMover#move_to!' do
    piece_mover = PieceMover.new
    let(:game) { FactoryGirl.create :game }

    it 'captures a piece BEFORE performing a move if the move is valid, unobstructed, and the square can be captured. returns true.' do
      game

      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      capture_piece = Pawn.new(:black, to_pos)
      pieces = [rook, capture_piece]

      white_capture_area_pos = Position.new_from_int(Position::WHITE_CAPTURE_INT)

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq true
      # check that the black pawn is captured
      expect(move_resolution.pieces[1].position.equals?(white_capture_area_pos)).to eq true
      # ???????????????????

      # 2 moves should exist in db. The move to to_pos and captured piece off board. ORDER MATTERS
      # inserted = Move.last(2)
      # expect(inserted.length).to eq(2)

      # # Check that the captured piece was moved off board
      # capture_move = inserted[0]
      # capture_from = Position.new_from_int(capture_move.from)
      # capture_to = Position.new_from_int(capture_move.to)

      # black_capture_pos = Position.new_from_int(Position::BLACK_CAPTURE_INT)

      # expect(capture_from.equals?(to_pos)).to eq true
      # expect(capture_to.equals?(black_capture_pos)).to eq true

      # # Check that the piece was moved to the to_pos
      # move = inserted[1]
      # move_from = Position.new_from_int(move.from)
      # move_to = Position.new_from_int(move.to)

      # expect(move_from.equals?(from_pos)).to eq true
      # expect(move_to.equals?(to_pos)).to eq true

    end

    it "a pawn captures another chess piece" do
      game
      from_pos = Position.new(3, 4)
      to_pos = Position.new(4, 5)

      white_pawn = Pawn.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_pawn, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      if !move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a rook captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(3, 0)

      white_rook = Rook.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_rook, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      if !move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a queen captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(3, 0)

      white_queen = Queen.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_queen, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      if !move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a king captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(2, 0)

      white_king = King.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_king, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      if !move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a bishop captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(7, 6)

      white_bishop = Bishop.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_bishop, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      if !move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a knight captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(0, 2)

      white_knight = Knight.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_knight, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      if !move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "returns false if move is obstructed" do
      game
      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 0))
      pieces = [rook, obstructor_piece]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      # OBSTRUCTED MOVE
      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq false
    end

    it "raises an ArgumentError for invalid positions" do
      game

      # INVALID MOVE
      to_pos = Position.new(-10, -10)

      from_pos = Position.new(0, 0)

      rook = Rook.new(:white, from_pos)
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 0))
      pieces = [rook, obstructor_piece]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      expect { PieceMover.move_to!(pieces, game.moves) }.to raise_error(ArgumentError)
    end

    it 'moves a piece to an empty square if the move is valid and is not obstructed.' do
      game
      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      pieces = [rook]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq true
    end
  end

end
