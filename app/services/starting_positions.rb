module StartingPositions
  STARTING_POSITIONS = [

    Rook.new(:white, Position.new(0, 0)),
    Knight.new(:white, Position.new(1, 0)),
    Bishop.new(:white, Position.new(2, 0)),
    Queen.new(:white, Position.new(3, 0)),
    King.new(:white, Position.new(4, 0)),
    Bishop.new(:white, Position.new(5, 0)),
    Knight.new(:white, Position.new(6, 0)),
    Rook.new(:white, Position.new(7, 0)),
    Pawn.new(:white, Position.new(0, 1)),
    Pawn.new(:white, Position.new(1, 1)),
    Pawn.new(:white, Position.new(2, 1)),
    Pawn.new(:white, Position.new(3, 1)),
    Pawn.new(:white, Position.new(4, 1)),
    Pawn.new(:white, Position.new(5, 1)),
    Pawn.new(:white, Position.new(6, 1)),
    Pawn.new(:white, Position.new(7, 1)),
    Pawn.new(:black, Position.new(0, 6)),
    Pawn.new(:black, Position.new(1, 6)),
    Pawn.new(:black, Position.new(2, 6)),
    Pawn.new(:black, Position.new(3, 6)),
    Pawn.new(:black, Position.new(4, 6)),
    Pawn.new(:black, Position.new(5, 6)),
    Pawn.new(:black, Position.new(6, 6)),
    Pawn.new(:black, Position.new(7, 6)),
    Rook.new(:black, Position.new(0, 7)),
    Knight.new(:black, Position.new(1, 7)),
    Bishop.new(:black, Position.new(2, 7)),
    Queen.new(:black, Position.new(3, 7)),
    King.new(:black, Position.new(4, 7)),
    Bishop.new(:black, Position.new(5, 7)),
    Knight.new(:black, Position.new(6, 7)),
    Rook.new(:black, Position.new(7, 7))

  ]
end
