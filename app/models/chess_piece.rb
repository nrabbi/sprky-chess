class ChessPiece < ApplicationRecord

  STARTING_POSITIONS = {
    white_rook_1: [0, 0],
    white_knight_1: [0, 1],
    white_bishop_1: [0, 2],
    white_queen: [0, 3],
    white_king: [0, 4],
    white_bishop_2: [0, 5],
    white_knight_2: [0, 6],
    white_rook_2: [0, 7],
    white_pawn_1: [1, 0],
    white_pawn_2: [1, 1],
    white_pawn_3: [1, 2],
    white_pawn_4: [1, 3],
    white_pawn_5: [1, 4],
    white_pawn_6: [1, 5],
    white_pawn_7: [1, 6],
    white_pawn_8: [1, 7],

    black_pawn_1: [6, 0],
    black_pawn_2: [6, 1],
    black_pawn_3: [6, 2],
    black_pawn_4: [6, 3],
    black_pawn_5: [6, 4],
    black_pawn_6: [6, 5],
    black_pawn_7: [6, 6],
    black_pawn_8: [6, 7],
    black_rook_1: [7, 0],
    black_knight_1: [7, 1],
    black_bishop_1: [7, 2],
    black_queen: [7, 3],
    black_king: [7, 4],
    black_bishop_2: [7, 5],
    black_knight_2: [7, 6],
    black_rook_2: [7, 7]
  }
end
