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
    # after_move_pieces is an array with all the chess pieces

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
    end

    result
  end

  def self.is_in_check?(my_color, pieces)
    opposite_king = pick_opposite_king(my_color, pieces)

    if opposite_king.nil?
      # happens in test cases, when only one king is on the board
      return false
    end

    my_pieces = pieces.select {|piece| piece.color == my_color }

    my_pieces.each do |piece|
      is_valid = piece.is_valid?(opposite_king.position)
      is_obstructed = piece.is_obstructed?(pieces, opposite_king.position)
      can_capture = piece.can_capture?(pieces, opposite_king.position)

      is_in_check = is_valid && !is_obstructed && can_capture

      if is_in_check
        #byebug
        return true
      end

    end

    false
  end

  def self.checks_exist?(after_move_pieces)
    # creates current state of board, returns true if any pieces could move to check opposite king
    # TODO: should also return alert with the pieces and moves causing check

    # update -- this will become the puts_opponent_into_check method
    # purpose should be to take a new move which has been created, then check if it has created any checks.
    # it will already have been validated

    # collect all current pieces
    # get the starting position
    after_move_pieces.each do |piece|
      from = piece.position
      from_integer = from.to_integer

      # get array of all the other positions on the board
      all_positions = (0..63).to_a
      all_positions.delete(from_integer)

      # make and collect new positions for each other square
      potential_destinations = []
      all_positions.each do |other_position|
        to = Position.new_from_int(other_position)
        if piece.is_valid?(to) && !piece.is_obstructed?(after_move_pieces, to)
          potential_destinations << to
        end
      end

      # check if moving this piece puts the opposite king into Check
      # opposite_king = pick_opposite_king(piece.color, after_move_pieces)

      potential_destinations.each do |destination|
        is_valid = piece.is_valid?(destination)
        moved_pieces = after_move_pieces.map(&:dup)
        thisPiece = moved_pieces.select { |p| p.position.equals?(piece.position) }[0]
        thisPiece.position = destination

        if is_in_check?(:white, moved_pieces)

          # debug output
          puts "White king is in check: "
          moved_pieces.each do |pp|
            puts "\t#{pp.class.name},#{pp.color}, #{pp.position.to_chess_position}."
          end
          # byebug

          return true
        elsif is_in_check?(:black, moved_pieces)

          # debug output
          puts "Black king is in check: "
          moved_pieces.each do |pp|
            puts "\t#{pp.class.name},#{pp.color}, #{pp.position.to_chess_position}."
          end
          # byebug

          return true
        end

      end

    end

    false
  end

  def self.pick_white_king(pieces)
    pieces.select {|piece| piece.class.to_s == "King" && piece.color == :white } [0]
  end

  def self.pick_black_king(pieces)
    pieces.select {|piece| piece.class.to_s == "King" && piece.color == :black } [0]
  end

  def self.pick_opposite_king(color, pieces)
    (color == :black) ? pick_white_king(pieces) : pick_black_king(pieces)
  end

  def self.apply_moves(_pieces, _moves)
    new_pieces = _pieces.map(&:dup)

    _moves.each do |move|
      # look up the piece to move, by matching from-coordinate
      # of this move to positions of all pieces
      this_piece = find_piece_for_coordinate(new_pieces, move_position_from(move))

      to_piece = find_piece_for_coordinate(new_pieces, move_position_to(move))

      if to_piece && this_piece.can_capture?(new_pieces, move_position_to(move))
        capture_int = to_piece.color == :black ? Position::WHITE_CAPTURE_INT : Position::BLACK_CAPTURE_INT
        to_piece.position = Position.new_from_int(capture_int)
      end
      # move piece to new position
      this_piece.position = move_position_to(move)
    end

    new_pieces
  end

  private

  def self.move_position_from(move)
    Position.new_from_int(move.from)
  end

  def self.move_position_to(move)
    Position.new_from_int(move.to)
  end

  def self.find_piece_for_coordinate(pieces, coordinate)
    pieces.find { |p| p.position.x == coordinate.x && p.position.y == coordinate.y }
  end
end
