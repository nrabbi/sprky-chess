class MoveResolution
  attr_accessor :error_message
  attr_accessor :pieces

  def initialize
    @error_message = ""
    @pieces = nil
  end

  def ok?
    @error_message.empty?
  end
end

class PieceMover

  # move_to!(pieces: ChessPiece[], moves: Move[], from: integer, to: integer)
  # -------------------------------
  # Moves a ChessPiece to a destination Position if a move is valid and unobstructed
  # Captured pieces are moved off the board
  def self.move_to!(_pieces, _moves)
    result = MoveResolution.new

    from = Position.new_from_int(_moves.last.from)
    to = Position.new_from_int(_moves.last.to)

    # 1) get the current state of the board:
    #     move pieces, remove any captured pieces

    # the new Move is created via current_game.moves.new
    # so it keeps the link to this game and all its moves.
    # in order to check if the move is valid, it can't be applied here
    # and needs to be sliced off
    result.pieces = apply_moves(_pieces, _moves[0..-2])

    # 2) find the chess piece being moved
    pieces = result.pieces.select { |piece| piece.position.equals?(from) }

    if pieces.count == 0
      # the piece might be captured, this is okay
      # result.error_message += "No piece found at #{from.to_chess_position}."
      return result
    elsif pieces.count > 1
      result.error_message += "Invalid number of chess pieces when moving: #{pieces.count}. Should be 1 piece."
      return result
    end
    thisChessPiece = pieces[0]

    # 3) check if this move is valid
    is_valid = thisChessPiece.is_valid?(to)

    # 4) check for obstruction
    is_obstructed = thisChessPiece.is_obstructed?(result.pieces, to)

    # 5)
    can_capture = thisChessPiece.can_capture?(result.pieces, to)

    after_move_pieces = apply_moves(result.pieces, [_moves[-1]])
    i_am_in_check = is_in_check(thisChessPiece.color, after_move_pieces)

    if can_capture && is_valid && !is_obstructed
      capture_int = thisChessPiece.color == :black ? Position::BLACK_CAPTURE_INT : Position::WHITE_CAPTURE_INT
      captured_piece = result.pieces.select { |piece| piece.position.equals?(to) }[0]
      captured_piece.position = Position.new_from_int(capture_int)
    end

    if !is_valid
      result.error_message += 'Invalid move. The move is invalid for that piece, it is not allowed to move there. '
      result.error_message += "When moving from #{from.to_chess_position} to #{to.to_chess_position}."
    elsif is_obstructed
      result.error_message += 'Invalid move. The piece is obstructed. '
      result.error_message += "When moving from #{from.to_chess_position} to #{to.to_chess_position}."
    elsif i_am_in_check
      result.error_message += 'Invalid move. This puts yourself into check.'
      result.error_message += "When moving from #{from.to_chess_position} to #{to.to_chess_position}."
    end

    result
  end

  def self.is_in_check_pos(color, pieces, king_position)
    # for every piece of opposite color, check if it can capture this king
    enemyPieces = pieces.select { |piece| piece.color != color }

    enemyPieces.each do |piece| 
      is_valid = piece.is_valid?(king_position)
      is_obstructed = piece.is_obstructed?(pieces, king_position)
      can_capture = piece.can_capture?(pieces, king_position)

      if is_valid && !is_obstructed && can_capture
        return true
      end
    end
    false
  end


  def self.is_in_check(color, pieces)
    king = find_king(color, pieces)

    if king.nil?
      # happens in test cases, when there is only one king on the board.
      return false
    end

    return is_in_check_pos(color, pieces, king.position)
  end

  def self.is_in_check_mate(color, pieces)
    king = find_king(color, pieces)

    if king.nil?
      # happens in test cases, when there is only one king on the board.
      return false
    end

    in_check_mate = false

    # 1) check if the king can move out of check
    new_king_positions = []
    for i in 0..63 do 
      pos = Position.new_from_int(i)
      is_valid = king.is_valid?(pos)
      if is_valid
        new_king_positions << pos
      end
    end

    new_pieces = pieces.map(&:dup)
    king = find_king(color, new_pieces)
    new_king_positions.each do |position|
      # temporarily move the king to the new position. Needed for correct capture
      # and obstruction checking.
      king.position = position

      in_check = is_in_check_pos(color, new_pieces, position)
      if in_check
        in_check_mate = true
      end
    end

    # 2) check if any own pieces can block the enemy pieces
    new_pieces = pieces.map(&:dup)
    friendly_pieces = new_pieces.select { |piece| piece.color == color && piece.class.name != "King"}
    
    for i in 0..63 do 
      pos = Position.new_from_int(i)

      friendly_pieces.each do |piece| 
        is_valid = piece.is_valid?(pos)
        is_obstructed = piece.is_obstructed?(pieces, pos)

        if is_valid && !is_obstructed
          # this position is good for this piece, now check 
          # if it blocks the check

          # temporarily move the piece to the new position. Needed for correct capture
          # and obstruction checking.
          old_position = piece.position
          piece.position = pos
          in_check = is_in_check(color, new_pieces)
          # restore old position for next loop run
          piece.position = old_position

          if !in_check
            return false
          end
        end
      end
    end

    in_check_mate
  end

  def self.find_king(color, pieces)
    return pieces.select { |piece| piece.class.name == 'King' && piece.color == color } [0]
  end

  def self.apply_moves(_pieces, _moves)
    new_pieces = _pieces.map(&:dup)

    _moves.each do |move|
      # look up the piece to move, by matching from-coordinate
      # of this move to positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move_position_from(move))

      to_piece = find_piece_for_coordinate(new_pieces, move_position_to(move))
      castle_move = this_piece.class == King && (move.from - move.to).abs == 2
      if to_piece && this_piece.can_capture?(new_pieces, move_position_to(move))
        capture_int = to_piece.color == :black ? Position::WHITE_CAPTURE_INT : Position::BLACK_CAPTURE_INT
        to_piece.position = Position.new_from_int(capture_int)
      elsif castle_move
        rook = find_piece_for_coordinate(new_pieces, rook_from_position(move))
        rook.position = Position.new_from_int(rook_to_position(rook))
      end

      # move piece to new position
      this_piece.position = move_position_to(move)


      # check promo move
      if move.promo
        promote(this_piece, move.promo, new_pieces)
      end

    end

    new_pieces
  end


  # promote(pawn: Pawn, promo: string, pieces: ChessPiece[])
  # -------------------------------
  # Replaces piece on board with player specified promotion
  def self.promote(pawn, promo, pieces)
    promo_piece = nil
    case promo
      when 'B'
        promo_piece = Bishop.new(pawn.color, pawn.position)
      when 'K'
        promo_piece = Knight.new(pawn.color, pawn.position)
      when 'R'
        promo_piece = Rook.new(pawn.color, pawn.position)
      when 'Q'
        promo_piece = Queen.new(pawn.color, pawn.position)
      else
        return
    end
    if promo_piece != nil
      pieces.delete(pawn)
      pieces.push(promo_piece)
    end
  end


  private

  def self.move_position_from(move)
    Position.new_from_int(move.from)
  end

  def self.move_position_to(move)
    Position.new_from_int(move.to)
  end

  def self.rook_from_position(castle_move)
    if castle_move.from == 4 && castle_move.to == 2
      Position.new_from_int(0)
    elsif castle_move.from == 4 && castle_move.to == 6
      Position.new_from_int(7)
    elsif castle_move.from == 60 && castle_move.to == 58
      Position.new_from_int(56)
    elsif castle_move.from == 60 && castle_move.to == 62
      Position.new_from_int(63)
    end
  end

  def self.rook_to_position(rook)
    if rook.position.to_integer == 0
      3
    elsif rook.position.to_integer == 7
      5
    elsif rook.position.to_integer == 56
      59
    elsif rook.position.to_integer == 63
      61
    end
  end

  def self.find_piece_for_coordinate(pieces, coordinate)
    pieces.find { |p| p.position.x == coordinate.x && p.position.y == coordinate.y }
  end
end
