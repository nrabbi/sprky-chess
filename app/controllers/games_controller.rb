class GamesController < ApplicationController
  # TODO: -- add before_action to authenticate_players! for :new, :create

  helper_method :get_piece_at

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.all
  end

  def board
    @game = Game.find(params[:id])
    pieces = StartingPositions::STARTING_POSITIONS

    piece_mover = PieceMover.new
    @after_move_pieces = piece_mover.apply_moves(pieces, @game.moves)
  end

  # x in [0, 7]
  # y in [0, 7]
  def get_piece_at(x, y)
    # returns nil if no piece @ position
    positions = @after_move_pieces
    positions.each do |piece|
      return piece if piece.position.x == x && piece.position.y == y
    end
    nil
  end

end

  private

def game_params
  params.require(:game).permit(:name)
end
