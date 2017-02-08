require 'rspec'
require 'rails_helper'

describe 'PieceMover' do

  describe 'PieceMover#move_to!' do
    it 'moves a piece to an empty square if the move is valid and is not obstructed' do
      # perform checks

      # move piece to square

    end

    it 'moves a piece to an occupied square if the move is valid, is not obstructed, and can be captured' do
      # perform checks

      # move piece to square

      # move captured piece off board
    end

    it "alerts the user of a bad move if the move is not valid or is obstructed" do
      # perform checks

      # alert user

      # no changes

    end
  end

end