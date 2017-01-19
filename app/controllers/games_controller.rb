class GamesController < ApplicationController
  
  def new
  end

  def create
  end

  def show
  end

  def index
  end

  def board
    @starting_positions = StartingPositions::STARTING_POSITIONS
    @moved_pieces = PieceMover::move_piece
  end

end
