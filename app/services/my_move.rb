class MyMove
  attr_accessor :to
  attr_reader :from
    # Coordinate: [x, y]

  def initialize(x, y)
    @from = [x, y]
    @to = []
  end

  def call
    # Coordinate: [x, y]

    # 1 pawn
    piece0 = MyChessPiece.new
    piece0.position = [0, 1]

    piece1 = MyChessPiece.new
    piece1.position = [1,2]

    @pieces = []
    @pieces << piece0
    @pieces << piece1

    @moves = []
    move = MyMove.new(piece0.position[0], piece0.position[1])
    # TODO: add code to check if move is valid.

    move.to << piece0.position[0]
    move.to << piece0.position[1] + 1  # applies the movement rule for a pawn

    @moves << move



    move1 = MyMove.new(piece1.position[0], piece1.position[1])
    move1.to << piece1.position[0]
    move1.to << piece1.position[1] + 1  # applies the movement rule for a pawn
    @moves << move1


    @afterMovementPieces = applyMoves(@pieces, @moves)
  end  

  private

  def findPieceForCoordinate(pieces, coordinate)
    pieces.each do |p|
      if p.position == coordinate
        return p
      end
    end

    # not found :-(
    return nil
  end


  def applyMoves(pieces, moves)
    newPieces = pieces.map do |p| p.dup end

    moves.each do |move|
      # 1. look up the piece for this piece by matching the coordinate
      #     of this move by positions of all pieces
      thisPiece = findPieceForCoordinate(newPieces, move.from)

      if thisPiece != nil
        # 2. move piece to new position
        thisPiece.position = move.to
      else
        # really bad - why is there a move defined on a piece
        # which doesn't exist????
      end


    end

    return newPieces
  end

end