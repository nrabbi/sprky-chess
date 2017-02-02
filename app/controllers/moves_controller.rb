class MovesController < ApplicationController
  def index
  end

  def new
    @game = Game.find(params[:game_id])
    @move = Move.new
  end

  def create
    @game = Game.find(params[:game_id])
    @move = @game.moves.create(move_params)
    redirect_to game_path(@game)
  end

  private
  def move_params
    params.require(:move).permit(:from, :to)
  end
end
