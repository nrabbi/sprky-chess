class CreateChessPieces < ActiveRecord::Migration[5.0]
  def change
    create_table :chess_pieces do |t|
      t.string :type
      t.integer :position

      t.timestamps
    end
  end
end
