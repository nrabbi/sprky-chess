class GamesController < ApplicationController
  before_action :authenticate_player!, only: [:new, :create, :update]

  helper_method :get_piece_at

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    if @game.valid?
      @game.created!
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = current_game
  end

  def index
    @games = Game.all
  end

  def board
    @game = current_game
    pieces = StartingPositions::STARTING_POSITIONS

    @after_move_pieces = PieceMover.apply_moves(pieces, @game.moves)

    black_capture_area_pos = Position.new_from_int(Position::BLACK_CAPTURE_INT)
    white_capture_area_pos = Position.new_from_int(Position::WHITE_CAPTURE_INT)

    @black_captured_pieces = @after_move_pieces.select { |piece| piece.position.equals?(black_capture_area_pos) }
    @white_captured_pieces = @after_move_pieces.select { |piece| piece.position.equals?(white_capture_area_pos) }

  end

  def available
    @games = Game.available
  end

  def update
    current_game.update_attributes(player_2_id: current_player.id)
    current_game.update_attributes(player_2_color: opposite_color(current_game))
    if current_game.save
      current_game.started!
      redirect_to game_board_path(current_game), notice: "Welcome! Let the game begin!"
    else
      render :available, status: :unauthorized
    end
  end

  # x in [0, 7]
  # y in [0, 7]
  def get_piece_at(x, y)
    # returns nil if no piece @ position
    # starting_positions = StartingPositions::STARTING_POSITIONS
    positions = @after_move_pieces
    positions.each do |piece|
      return piece if piece.position.x == x && piece.position.y == y
    end
    nil
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_1_color, :player_2_id, :player_2_color).merge(player_1_id: current_player.id)
  end

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def opposite_color(current_game)
    if current_game.player_1_color == "Black"
      "White"
    elsif current_game.player_1_color == "White"
      "Black"
    end
  end

end
