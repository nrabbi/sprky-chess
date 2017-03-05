class Castler

  def initialize(castle_pieces, after_move_pieces)
    binding.pry
    @king = castle_pieces.detect{|p| p.class == King }
    @rook = castle_pieces.detect{|p| p.class == Rook }
    @after_move_pieces = after_move_pieces
  end

  def call
    binding.pry
    # @rook.is_obstructed?
    # @king doesn't get into check?
    set_castled_positions
    # return updated move to moves_controller to be saved
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


end