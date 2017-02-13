class CheckDeterminer
  
  def determine_check_after_move 
    # loop through all current positions
    # checking_pieces = []
    # current_pieces.each do |piece|
      # checking_pieces << piece if piece.can_check?
    # end
    # if checking_pieces.any?
      # short version (no details):
      # true
      # long version (gives details):
      # checking_pieces.each do |piece|
        # send error like "King is in check by #{piece} at #{position}"
      # end
    # end
  end

  def determine_check_before_move
    # move resolution/validation
    # determine_check_after_move
    # if checking_pieces.any?
      # make the move not valid, error: "King cannot be moved into check"
    # end
  end

  def can_check?
    # return true if a piece is able to move into check (w/ other player)
    # will need to check all possible moves for that piece
    # how?
  end

end
