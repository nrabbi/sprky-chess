class DropChessPieceTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :chess_pieces if ActiveRecord::Base.connection.table_exists? :chess_pieces
  end
end
