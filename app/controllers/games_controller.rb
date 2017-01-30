class GamesController < ApplicationController

  helper_method :get_piece_at

  def new; end

  def create; end

  def show; end

  def index; end

  def board
    pieces = StartingPositions::STARTING_POSITIONS
    moves = []
    # these are temporary "dummy" moves
    # TODO -- get moves from user input
    move0 = Move.new(from: "A1", to: "A3")
    moves << move0 

    # move1 = Move.new(pieces[1].position.x, pieces[1].position.y)
    # move1.to.x = move1.from.x
    # move1.to.y = move1.from.y + 2
    # moves << move1

    # move2 = Move.new(pieces[2].position.x, pieces[2].position.y)
    # move2.to.x = move2.from.x
    # move2.to.y = move2.from.y + 2
    # moves << move2

    piece_mover = PieceMover.new
    @after_move_pieces = piece_mover.move_pieces(pieces, moves)
  end

  # x in [0, 7]
  # y in [0, 7]
  def get_piece_at(x, y)
    # returns nil if no piece @ position
    # starting_positions = StartingPositions::STARTING_POSITIONS
    positions = @after_move_pieces
    positions.each do |piece|
      return piece if piece.position.x == x && piece.position.y == y
    end
    nil
  end

end
