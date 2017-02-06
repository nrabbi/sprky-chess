class MovesController < ApplicationController
  def index
    set_game
  end

  def new
    set_game
    @move = Move.new
  end

  def create
    set_game
    @move = @game.moves.create(move_params)
    if @move.valid?
      redirect_to game_board_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def move_params
    params.require(:move).permit(:from, :to)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

end
