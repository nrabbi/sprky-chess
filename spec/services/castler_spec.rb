require 'rspec'
require 'rails_helper'

RSpec.describe "Castler" do
  let(:castle_pieces_a) { [King.new(:white, Position.new(4, 0)), 
                          Rook.new(:white, Position.new(0, 0))] }
  let(:castle_pieces_b) { [King.new(:white, Position.new(4, 0)), 
                          Rook.new(:white, Position.new(7, 0))] }
  let(:castle_pieces_c) { [King.new(:black, Position.new(4, 7)), 
                          Rook.new(:black, Position.new(0, 7))] }
  let(:castle_pieces_d) { [King.new(:black, Position.new(4, 7)), 
                          Rook.new(:black, Position.new(7, 7))] }
  let(:castler_a) { Castler.new(castle_pieces_a, after_move_pieces_a)}
  let(:castler_b) { Castler.new(castle_pieces_b, after_move_pieces_b)}
  let(:castler_c) { Castler.new(castle_pieces_c, after_move_pieces_c)}
  let(:castler_d) { Castler.new(castle_pieces_d, after_move_pieces_d)}
  let(:castler_e) { Castler.new(castle_pieces_a, after_move_pieces_e)}
  let(:castler_f) { Castler.new(castle_pieces_b, after_move_pieces_f)}
  let(:castler_g) { Castler.new(castle_pieces_c, after_move_pieces_g)}
  let(:castler_h) { Castler.new(castle_pieces_d, after_move_pieces_h)}

context 'when valid castle' do
  let(:after_move_pieces_a) { [castle_pieces_a[0], castle_pieces_a[1], 
                            Rook.new(:black, Position.new(1, 1)),
                            Bishop.new(:black, Position.new(3, 2)),
                            Queen.new(:black, Position.new(7, 1))] }
  let(:after_move_pieces_b) { [castle_pieces_b[0], castle_pieces_b[1], 
                            Rook.new(:black, Position.new(7, 1)),
                            Bishop.new(:black, Position.new(4, 3)),
                            Queen.new(:black, Position.new(0, 2))] }
  let(:after_move_pieces_c) { [castle_pieces_c[0], castle_pieces_c[1], 
                            Rook.new(:white, Position.new(1, 6)),
                            Bishop.new(:white, Position.new(3, 5)),
                            Queen.new(:white, Position.new(7, 6))] }
  let(:after_move_pieces_d) { [castle_pieces_d[0], castle_pieces_d[1], 
                            Rook.new(:white, Position.new(7, 6)),
                            Bishop.new(:white, Position.new(4, 4)),
                            Queen.new(:white, Position.new(0, 5))] }
  

  it "returns correct new king and rook positions (Kingside White)" do
    castler_a
    castler_a.call
    expect(castler_a.results[1].position.to_integer).to eq(2)
    expect(castler_a.results[3].position.to_integer).to eq(3)
  end
  it "returns correct new king and rook positions (Queenside White)" do
    castler_b
    castler_b.call
    expect(castler_b.results[1].position.to_integer).to eq(6)
    expect(castler_b.results[3].position.to_integer).to eq(5)
  end
  it "returns correct new king and rook positions (Kingside Black)" do
    castler_c
    castler_c.call
    expect(castler_c.results[1].position.to_integer).to eq(58)
    expect(castler_c.results[3].position.to_integer).to eq(59)
  end
  it "returns correct new king and rook positions (Queenside Black)" do
    castler_d
    castler_d.call
    expect(castler_d.results[1].position.to_integer).to eq(62)
    expect(castler_d.results[3].position.to_integer).to eq(61)
  end
end

context 'when invalid castle' do
  # Castle is obstructed
  let(:after_move_pieces_a) { [castle_pieces_a[0], castle_pieces_a[1], 
                            Pawn.new(:black, Position.new(1, 0))] }
  let(:after_move_pieces_b) { [castle_pieces_b[0], castle_pieces_b[1], 
                            Pawn.new(:black, Position.new(6, 0))] }
  let(:after_move_pieces_c) { [castle_pieces_c[0], castle_pieces_c[1], 
                            Pawn.new(:black, Position.new(1, 7))] }
  let(:after_move_pieces_d) { [castle_pieces_d[0], castle_pieces_d[1], 
                            Pawn.new(:black, Position.new(6, 7))] }
  # King moves into check
  let(:after_move_pieces_e) { [castle_pieces_a[0], castle_pieces_a[1], 
                            Queen.new(:black, Position.new(2, 1))] }
  let(:after_move_pieces_f) { [castle_pieces_b[0], castle_pieces_b[1], 
                            Queen.new(:black, Position.new(6, 1))] }
  let(:after_move_pieces_g) { [castle_pieces_c[0], castle_pieces_c[1], 
                            Queen.new(:white, Position.new(2, 6))] }
  let(:after_move_pieces_h) { [castle_pieces_d[0], castle_pieces_d[1], 
                            Queen.new(:white, Position.new(6, 6))] }
  it "prevents king-checking castle" do
    castler_e
    castler_e.call
    expect(castler_e.error_message).to include("The castling move puts your king into check")
    castler_f
    castler_f.call
    expect(castler_f.error_message).to include("The castling move puts your king into check")
    castler_g
    castler_g.call
    expect(castler_g.error_message).to include("The castling move puts your king into check")
    castler_h
    castler_h.call
    expect(castler_h.error_message).to include("The castling move puts your king into check")
  end

  it "prevents obstructed castle" do
    castler_a
    castler_a.call
    expect(castler_a.error_message).to include("The castling move is obstructed.")
    castler_b
    castler_b.call
    expect(castler_b.error_message).to include("The castling move is obstructed.")
    castler_c
    castler_c.call
    expect(castler_c.error_message).to include("The castling move is obstructed.")
    castler_d
    castler_d.call
    expect(castler_d.error_message).to include("The castling move is obstructed.")
  end
end

end