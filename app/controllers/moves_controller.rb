class MovesController < ApplicationController

  before_action :current_game, only: [:index, :new, :create]

  def index; end

  def new
    @move = Move.new
  end

  def create
    new_move = current_game.moves.new(from: from_position.to_integer, to: to_position.to_integer)
    if correct_player_turn? && new_move.valid?
      # @move = @game.moves.create(move_params)
      new_move.save
      redirect_to game_board_path(@game)
    elsif !correct_player_turn?
      redirect_to game_board_path(@game), alert: "Hey, it's not your turn!"
    else
      redirect_to game_board_path(@game), notice: new_move.errors
    end
  end

  def player_turn(current_game)
    current_game.moves.count % 2 == 0 ? "White" : "Black"
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

  def correct_player_turn?
    if player_turn(current_game) == current_game.player_1_color
      player_turn_id = current_game.player_1_id
    else
      player_turn_id = current_game.player_2_id
    end
    player_turn_id == current_player.id ? true : false
  end

end
