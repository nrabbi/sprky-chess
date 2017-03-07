class Castler

  attr_accessor :results, :castle_error

  def initialize(castle_pieces, after_move_pieces)
    @king = castle_pieces.detect{|p| p.class == King }
    @rook = castle_pieces.detect{|p| p.class == Rook }
    @after_move_pieces = after_move_pieces
    @results = []
  end

  def call
    # binding.pry
    king_start = @king.dup
    rook_start = @rook.dup
    if castle_obstructed?
      @castle_error = "The castling move is obstructed."
    elsif castle_checks
      @castle_error = "The castling move puts your king into check, from the piece(s) at #{castle_checks}."
    else
      set_castled_positions
      @results << king_start << @king << rook_start << @rook
    end
  end

  private

  # captured_piece = result.pieces.select { |piece| piece.position.equals?(to) }[0]
  # captured_piece.position = Position.new_from_int(capture_int)

  def set_castled_positions
    if left_white_castle
      @king.position = Position.new_from_int(2)
      @rook.position = Position.new_from_int(3)
    elsif right_white_castle
      @king.position = Position.new_from_int(6)
      @rook.position = Position.new_from_int(5)
    elsif left_black_castle
      @king.position = Position.new_from_int(58)
      @rook.position = Position.new_from_int(59)
    elsif right_black_castle
      @king.position = Position.new_from_int(62)
      @rook.position = Position.new_from_int(61)
    else 
      raise NoMethodError, 
      "Not a valid castling move for King at #{@king.position.to_integer} and Rook at #{@rook.position.to_integer}"
    end
    castled_positions = [@king, @rook]
  end

  def left_white_castle
    @rook.position.to_integer == 0 && @king.position.to_integer == 4
  end

  def right_white_castle
    @rook.position.to_integer == 7 && @king.position.to_integer == 4
  end

  def left_black_castle
    @rook.position.to_integer == 56 && @king.position.to_integer == 60
  end

  def right_black_castle
    @rook.position.to_integer == 63 && @king.position.to_integer == 60
  end

  def castle_obstructed?
    obstructors = []
    if left_white_castle
      (1..3).each do |square|
        obstructors << @after_move_pieces.select { |piece| piece.position.to_integer == square }
      end
    elsif right_white_castle
      (5..6).each do |square|
        obstructors << @after_move_pieces.select { |piece| piece.position.to_integer == square }
      end
    elsif left_black_castle
      (57..59).each do |square|
        obstructors << @after_move_pieces.select { |piece| piece.position.to_integer == square }
      end
    elsif right_black_castle
      (61..62).each do |square|
        obstructors << @after_move_pieces.select { |piece| piece.position.to_integer == square }
      end
    end
    obstructors.flatten.empty? ? false : true
  end

  def castle_checks
    check_moves = []
    black_pieces = @after_move_pieces.select { |piece| piece.color == :black }
    white_pieces = @after_move_pieces.select { |piece| piece.color == :white }
    if left_white_castle
      black_pieces.each do |piece| 
        (2..4).each do |square|
          possible_move = find_check_moves(square, piece)
          check_moves << possible_move unless possible_move.nil?
        end
      end
    elsif right_white_castle
      black_pieces.each do |piece| 
        (4..6).each do |square|
          possible_move = find_check_moves(square, piece)
          check_moves << possible_move unless possible_move.nil?
        end
      end
    elsif left_black_castle 
      white_pieces.each do |piece| 
        (58..60).each do |square|
          possible_move = find_check_moves(square, piece)
          check_moves << possible_move unless possible_move.nil?
        end
      end
    elsif right_black_castle
      white_pieces.each do |piece| 
        (60..62).each do |square|
          possible_move = find_check_moves(square, piece)
          check_moves << possible_move unless possible_move.nil?
        end
      end
    end
    check_moves.empty? ? nil : check_moves
  end

  def find_check_moves(square, piece)
    @king.position = Position.new_from_int(square)
    is_valid = piece.is_valid?(@king.position)
    is_obstructed = piece.is_obstructed?(@after_move_pieces, @king.position)
    can_capture = piece.can_capture?(@after_move_pieces, @king.position)
    possible_move = piece.position.to_chess_position if is_valid && !is_obstructed && can_capture
  end

end