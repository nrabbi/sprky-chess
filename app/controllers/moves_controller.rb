class MovesController < ApplicationController

  before_action :current_game, only: [:index, :new, :create]

  def index; end

  def new
    @move = Move.new
  end

  def create
    new_move = current_game.moves.new(from: from_position.to_integer, to: to_position.to_integer)

    if new_move.valid?
      @move = @game.moves.create(move_params)
          # binding.pry
      checks = CheckDeterminer.new(new_move).checks_exist?
      if checks.nil?
        redirect_to game_board_path(@game)
      else
        redirect_to game_board_path(@game), alert: checks.alerts.join(" \n")
      end
    else
      redirect_to game_board_path(@game), notice: new_move.errors
    end
  end

  private

  def move_params
    params.require(:move).permit(:from, :to)
  end

  def current_game
    @game ||= Game.find(params[:game_id])
  end

  def from_position
    @from_position ||= Position.new_from_int(move_params[:from].to_i)
  end

  def to_position
    @to_position ||= Position.new_from_int(move_params[:to].to_i)
end

end
