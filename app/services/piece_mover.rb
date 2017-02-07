class PieceMover

  def move_to!(new_x, new_y)
    # removes a chesspiece and updates the database if the destination block is being used and is a piece of different color
     if block_in_use(new_x, new_y) == true && opponent_check? true && pawn.can_capture? false
       # Do something
       remove_piece(new_x,new_y)
       update_attributes(new_x,new_y)
     end

     if pawn.can_capture? true
       remove_piece(new_x,new_y)
       update_attributes(new_x,new_y)
     end

  end

  def move_pieces(pieces, moves)
    moved_pieces = apply_moves(pieces, moves)
  end

  private

  # methods for move_to
  # checks the board to see if the co-ordinate is already in use or not
  def block_in_use?(x_pos, y_pos)
    # compare the given position with the data structure that holds the info about position of all chesspieces
    # if a chesspiece exists on the given location then return true
  end
  # equals (postion.rb)

  def opponent_check?
    # check if the opponent is of different color
  end

  def remove_piece (x_pos, y_pos)
    #You could have a “status” flag on the piece that will be one of “onboard” or “captured”.
    #You could set the piece’s x/y coordinates to nil
    #You could delete the item from the database.
  end

  # def square_letters
  #   ["A", "B", "C", "D", "E", "F", "G", "H"]
  # end

  def move_position_from(move)
    Position.new_from_int(move.from)
  end

  def move_position_to(move)
    Position.new_from_int(move.to)
  end

  def find_piece_for_coordinate(pieces, coordinate)
    pieces.find { |p| p.position.x == coordinate.x && p.position.y == coordinate.y }
  end

  def apply_moves(pieces, moves)
    new_pieces = pieces.map(&:dup)

    moves.each do |move|
      # look up the piece to move, by matching from-coordinate
      #  of this move to positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move_position_from(move))
      unless this_piece.nil?
        # move piece to new position
        this_piece.position = move_position_to(move)
      end
    end
    new_pieces
  end
end
