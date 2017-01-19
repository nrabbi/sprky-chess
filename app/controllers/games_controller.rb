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
    @current_piece_positions = PieceMover::move_piece
  end

end
