class Castler

  attr_accessor :results, :error_message

  def initialize(castle_pieces, after_move_pieces)
    @king = castle_pieces.detect { |p| p.class == King }
    @rook = castle_pieces.detect { |p| p.class == Rook }
    @after_move_pieces = after_move_pieces
    @results = []
    @error_message = ""
  end

  def call
    if castle_obstructed?
      @error_message = "The castling move is obstructed."
    elsif castle_checks
      @error_message = "The castling move puts your king into check,
      from the piece(s) at #{castle_checks}."
    else
      king_start = @king.dup
      rook_start = @rook.dup
      set_castled_positions
      @results << king_start << @king << rook_start << @rook
    end
  end

  private

  def set_castled_positions
    case @king.position.to_integer
    when 4
      @rook.position.to_integer.zero? ? white_queenside_positions : white_kingside_positions
    when 60
      @rook.position.to_integer == 56 ? black_queenside_positions : black_kingside_positions
    else
      @error_message = "Not a valid castling move for
      King at #{@king.position.to_chess_position} and
      Rook at #{@rook.position.to_chess_position}"
    end
  end

  def white_queenside_positions
    @king.position = Position.new_from_int(2)
    @rook.position = Position.new_from_int(3)
  end

  def white_kingside_positions
    @king.position = Position.new_from_int(6)
    @rook.position = Position.new_from_int(5)
  end

  def black_queenside_positions
    @king.position = Position.new_from_int(58)
    @rook.position = Position.new_from_int(59)
  end

  def black_kingside_positions
    @king.position = Position.new_from_int(62)
    @rook.position = Position.new_from_int(61)
  end

  def castle_obstructed?
    case @king.position.to_integer
    when 4
      obstructors = @rook.position.to_integer.zero? ? get_obstructors(1, 3) : get_obstructors(5, 6)
    when 60
      obstructors = @rook.position.to_integer == 56 ? get_obstructors(57, 59) : get_obstructors(61, 62)
    end
    obstructors.flatten.empty? ? false : true
  end

  def castle_checks
    case @king.position.to_integer
    when 4
      check_moves = @rook.position.to_integer.zero? ? get_queenside_checks(2, 4, black_pieces) : get_kingside_checks(4, 6, black_pieces)
    when 60
      check_moves = @rook.position.to_integer == 56 ? get_queenside_checks(58, 60, white_pieces) : get_kingside_checks(60, 62, white_pieces)
    end
    check_moves.empty? ? nil : check_moves
  end

  def black_pieces
    @after_move_pieces.select { |piece| piece.color == :black }
  end

  def white_pieces
    @after_move_pieces.select { |piece| piece.color == :white }
  end

  def find_check_moves(square, piece)
    @king.position = Position.new_from_int(square)
    is_valid = piece.is_valid?(@king.position)
    is_obstructed = piece.is_obstructed?(@after_move_pieces, @king.position)
    can_capture = piece.can_capture?(@after_move_pieces, @king.position)
    piece.position.to_chess_position if is_valid && !is_obstructed && can_capture
  end

  def get_queenside_checks(start_sq, finish_sq, pieces, check_moves = [])
    pieces.each do |piece|
      (start_sq..finish_sq).each do |square|
        possible_move = find_check_moves(square, piece)
        check_moves << possible_move unless possible_move.nil?
      end
    end
    check_moves
  end

  def get_kingside_checks(start_sq, finish_sq, pieces, check_moves = [])
    pieces.each do |piece|
      finish_sq.downto(start_sq).each do |square|
        possible_move = find_check_moves(square, piece)
        check_moves << possible_move unless possible_move.nil?
      end
    end
    check_moves
  end

  def get_obstructors(start_sq, finish_sq, obstructors = [])
    (start_sq..finish_sq).each do |square|
      obstructors << @after_move_pieces.select { |piece| piece.position.to_integer == square }
    end
    obstructors
  end

end
