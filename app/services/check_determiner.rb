class CheckDeterminer

  attr_accessor :after_move_pieces

  def initialize(params)
    @game = Game.find(params[:game_id])
    @from = params[:from]
    @to = params[:to]
  end
  
  def checks_exist?
    # creates current state of board, returns true if any pieces could move to check opposite king
    # TODO: should also return alert with the pieces and moves causing check

    # update -- this will become the puts_opponent_into_check method
    # purpose should be to take a new move which has been created, then check if it has created any checks.
    # it will already have been validated 
    starting_positions = StartingPositions::STARTING_POSITIONS
    potential_destinations = []
    potential_moves = []
    unvalidated_check_moves = []
    validated_check_moves = []
    # collect all current pieces
    @after_move_pieces = PieceMover.apply_moves(starting_positions, current_game.moves)
    # get the starting position
    @after_move_pieces.each do |piece|
      from = piece.position
      from_integer = from.to_integer
      # get array of all the other positions on the board
      all_positions = (0..63).to_a
      all_positions.delete(from_integer)
      # make and collect new positions for each other square
      all_positions.each do |other_position|
        to = Position.new_from_int(other_position)
        potential_destinations << to
        # make a new move for every potential_destination
        new_move = current_game.moves.new(from: from.to_integer, to: to.to_integer)
        potential_moves << new_move
      end
      potential_moves.each do |move|
        if move.to == opposite_king_position(piece)
          unvalidated_check_moves << move
        end
      end
      unvalidated_check_moves.each do |move|
        if move.valid?
          validated_check_moves << move
        end
      end
    end
    if validated_check_moves.any?
      true
    else
      false
      # TODO send piece name and destination as error message
    end
  end

  def puts_self_into_check
    
  end

  def puts_opponent_into_check(after_move_pieces, to)

  end

  private 

  def current_game
    @game ||= Game.find(params[:game_id])
  end

  def white_king_position
    white_king = @after_move_pieces.select {|piece| piece.class.to_s == "King" && piece.color == :white }
    white_king.first.position.to_integer
  end
  
  def black_king_position
    black_king = @after_move_pieces.select {|piece| piece.class.to_s == "King" && piece.color == :black }
    black_king.first.position.to_integer
  end

  def opposite_king_position(piece)
    if piece.color == :black
      white_king_position
    else
      black_king_position
    end
  end

end
