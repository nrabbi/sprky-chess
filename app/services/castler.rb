class Castler
  attr_accessor :castle_error

  def initialize(castle_pieces, after_move_pieces)
    @king = castle_pieces.detect{|p| p.class == King }
    @rook = castle_pieces.detect{|p| p.class == Rook }
    @after_move_pieces = after_move_pieces
  end

  def call
    if castle_obstructed?
      castle_error = "The castling move is obstructed."
    # elsif castle_contains_checks?
    #   castle_error = "The castling move puts your king into check."
    else
      set_castled_positions and return
    end
    # binding.pry
    return castle_error unless castle_error.empty?
  end

  private

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
    obstructors.empty? ? false : true
  end

  def castle_contains_checks?
    # check if king does not move into check
  end

end