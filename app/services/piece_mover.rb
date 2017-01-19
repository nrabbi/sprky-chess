module PieceMover
  def self.move_piece
    # Coordinate: [x, y]


    @pieces = []

    starting_positions = StartingPositions::STARTING_POSITIONS
    # if not first move, this should get loaded w/a current_positions hash instead
    starting_positions.each do |piece|
      new_piece = ChessPieceBuilder.new
      new_piece.name = piece[0].to_s
      new_piece.position = piece[1]
      @pieces << new_piece
    end
    puts @pieces.inspect

    # piece0 = ChessPieceBuilder.new
    # piece0.position = [0, 1]

    # piece1 = ChessPieceBuilder.new
    # piece1.position = [1,2]

   
    # @pieces << piece0
    # @pieces << piece1

    @moves = []
    move = MoveBuilder.new(piece0.position[0], piece0.position[1])
    # TODO: add code to check if move is valid.

    move.to << piece0.position[0]
    move.to << piece0.position[1] + 1  # applies the movement rule for a pawn

    @moves << move

    @moves.each do |move|
    end

    move1 = MoveBuilder.new(piece1.position[0], piece1.position[1])
    move1.to << piece1.position[0]
    move1.to << piece1.position[1] + 1  # applies the movement rule for a pawn
    @moves << move1

    # binding.pry
    @moved_pieces = apply_moves(@pieces, @moves)
    # TODO -- get @pieces values loaded from actual pieces hash
  end  

  private

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