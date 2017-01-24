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
    # @starting_positions = StartingPositions::STARTING_POSITIONS
    # @current_piece_positions = PieceMover::move_piece
  end

  # x in [0, 7]
  # y in [0, 7]
  def get_piece_at(x, y)
    # returns nil if no piece @ position
    starting_positions = StartingPositions::STARTING_POSITIONS

    starting_positions.each do |piece| 
      if piece.position.x == x && piece.position.y == y
        return piece
      end
    end

    nil

  end

end
