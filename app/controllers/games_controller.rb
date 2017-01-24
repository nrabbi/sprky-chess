class GamesController < ApplicationController

  helper_method :get_piece_at
  
  def new
  end

  def create
  end

  def show
  end

  def index
  end

  def board
    pieces = StartingPositions::STARTING_POSITIONS

    moves = []
    move0 = Move.new(pieces[0].position.x, pieces[0].position.y)
    move0.to.x = move0.from.x
    move0.to.y = move0.from.y + 2
    moves << move0

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
      if piece.position.x == x && piece.position.y == y
        return piece
      end
    end
    nil
  end

end
