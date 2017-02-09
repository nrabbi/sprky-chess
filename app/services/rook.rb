class Rook < ChessPiece

  def is_valid?(destination)
    x_only_move = (position.x - destination.x).abs > 0 && (position.y - destination.y).abs == 0
    y_only_move = (position.y - destination.y).abs > 0 && (position.x - destination.x).abs == 0

    (x_only_move || y_only_move) && inside_board_boundaries?(destination.x, destination.y)
  end

  def is_obstructed?(pieces, destination)
    # rook can move n squares in any direction

    return true unless inside_board_boundaries?(destination.x, destination.y)

    rook = self

    cellsTouched = [destination]

    # determine which axis and in which direction the rook is moving
    n = 0
    n = if destination.x > rook.position.x
          destination.x - rook.position.x
        else
          rook.position.x - destination.x
        end

    if n > 0
      # going along x axis

      # then determine all cells being touched when the rook would
      # do this move

      # this is a little tricky:
      # the rook itself is in the parameter "pieces". When comparing all the pieces
      # with all touched cells, it can obstruct itself.
      # n-1 combined with the +1 makes sure the rook's position is not in the
      # array of touched cells, thus it can not obstruct itself.
      (n - 1).times do |i|
        cellsTouched << Position.new(position.x + i + 1, position.y)
      end
    else
      # going along y axis

      # see above

      n = if destination.y > rook.position.y
            destination.y - rook.position.y
          else
            rook.position.y - destination.y
          end

      # see above
      (n - 1).times do |i|
        cellsTouched << Position.new(position.x, position.y + i + 1)
      end
    end

    pieces.each do |piece|
      cellsTouched.each do |position|
        return true if (piece.position.x == position.x) && (piece.position.y == position.y) && piece.color == color
      end
    end

    false
  end

  def html_icon
    @color == :white ? "&#9814;" : "&#9820;"
  end

end
