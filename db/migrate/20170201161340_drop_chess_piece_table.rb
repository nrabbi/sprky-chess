class DropChessPieceTable < ActiveRecord::Migration[5.0]
  def change
        drop_table :chess_pieces
  end
end
