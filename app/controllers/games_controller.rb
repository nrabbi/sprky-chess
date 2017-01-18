class GamesController < ApplicationController
  def show
    # Piece positions are taken from ChessPiece::STARTING_POSITIONS
    @positions = StartingPositions::STARTING_POSITIONS
    # if @positions.moves.any?
    #   # apply moves
    # end
  end

end
