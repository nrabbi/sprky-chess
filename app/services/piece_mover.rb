module PieceMover
  def self.move_piece
    # Coordinate: [x, y]


    @pieces = []

    starting_positions = StartingPositions::STARTING_POSITIONS
    # TODO -- when not first move, this should get loaded w/a current_positions hash instead
    starting_positions.each do |piece|
      new_piece = ChessPieceBuilder.new
      new_piece.name = piece[0].to_s
      new_piece.position = piece[1]
      @pieces << new_piece
    end
    puts @pieces.inspect


    @moves = []
    @pieces.each do |piece| # this method takes a collection of moves applies them to pieces
      new_move = MoveBuilder.new(piece.position[0], piece.position[1])
      # TODO: add code to check if move is valid.
      new_move.to << piece.position[0] + 1 << piece.position[1] + 1
      # move.to << new_x_axis_position << new_y_axis_position
      @moves << new_move # stores results of moves
    end

    @moved_pieces = apply_moves(@pieces, @moves)
    # TODO -- get @pieces values loaded from actual pieces hash
  end  

  private

  def self.new_x_axis_position
    # TODO -- new position is given by user 
  end

  def self.new_y_axis_position
    (move.position[1] + move_y_distance)
    # TODO - new position is given by user 
  end

  def self.find_piece_for_coordinate(pieces, coordinate)
    pieces.each do |p|
      if p.position == coordinate
        return p
      end
    end

    # not found :-(
    return nil
  end

  def self.apply_moves(pieces, moves)
    new_pieces = pieces.map do |p| p.dup end

    moves.each do |move|
      # 1. look up the piece for this piece by matching the coordinate
      #     of this move by positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move.from)

      if this_piece != nil
        # 2. move piece to new position
        this_piece.position = move.to
      else
        # really bad - why is there a move defined on a piece
        # which doesn't exist????
      end
    end

    return new_pieces
  end
end