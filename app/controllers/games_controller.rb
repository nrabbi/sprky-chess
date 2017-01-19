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
    @moved_pieces = PieceMover::move_piece
  end

end
