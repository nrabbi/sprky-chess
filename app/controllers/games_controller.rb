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
      redirect_to game_board_path(@game)    
    else
      render :new, status: :unprocessable_entity
    end
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

    @black_player = black_player
    @white_player = white_player


    # JESSE
    @player_turn = player_turn(current_game)
    @current_player_color = current_player_color(current_game)
    @opposite_player = opposite_player(current_game)
    @opposite_player_color = opposite_color(@current_player_color)
  end

  def black_player
    if @current_game.player_1_color == "Black"
      if current_player.id == @current_game.player_1_id
        current_player
      else
        Player.find_by(id: @current_game.player_1_id)
      end
    else
      if current_player.id == @current_game.player_2_id
        current_player
      else
        Player.find_by(id: @current_game.player_2_id)
      end
    end
  end

  def white_player
    if @current_game.player_1_color == "White"
      if current_player.id == @current_game.player_1_id
        current_player
      else
        Player.find_by(id: @current_game.player_1_id)
      end
    else
      if current_player.id == @current_game.player_2_id
        current_player
      else
        Player.find_by(id: @current_game.player_2_id)
      end
    end
  end

  def available
    @games = Game.available
  end

  def update
    current_game.update_attributes(player_2_id: current_player.id)
    current_game.update_attributes(player_2_color: opposite_color(current_game.player_1_color))
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

  def player_turn(current_game)
    current_game.moves.count % 2 == 0 ? "White" : "Black"
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_1_color, :player_2_id, :player_2_color).merge(player_1_id: current_player.id)
  end

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def opposite_color(color)
    if color == "Black"
      "White"
    elsif color == "White"
      "Black"
    end
  end

  def player_info(color)
    color
  end

  def current_player_color(current_game)
    if current_player && current_player.id == current_game.player_1_id
      current_game.player_1_color
    elsif current_player && current_player.id == current_game.player_2_id
      current_game.player_2_color
    else
      # current_player is not playing this game or no current_player
      return
    end
  end

  def opposite_player(current_game)
    if current_game.started? && current_player
      current_player.id == current_game.player_1_id ? opp_player = current_game.player_2_id : opp_player = current_game.player_1_id
      Player.find(opp_player)
    else 
      # current_player is not playing this game or no current_player
      return
    end
  end

  def player_1_email
    Player.find(current_game.player_1_id).email
  end

  def player_2_email
    current_game.player_2_id.nil? ? "(no opponent has joined yet)" : Player.find(current_game.player_2_id).email
  end

end
