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
    piece0 = MyChessPiece.new(0, 1)

    piece1 = MyChessPiece.new(0, 1)

    @pieces = []
    @pieces << piece0
    @pieces << piece1

    @moves = []
    move = MyMove.new(piece0.position.x, piece0.position.y)
    # TODO: add code to check if move is valid.

    move.to << piece0.position.x
    move.to << piece0.position.y + 1  # applies the movement rule for a pawn

    @moves << move



    move1 = MyMove.new(piece1.position.x, piece1.position.y)
    move1.to << piece1.position.x
    move1.to << piece1.position.y + 1  # applies the movement rule for a pawn
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