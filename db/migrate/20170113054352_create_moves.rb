class CreateMoves < ActiveRecord::Migration[5.0]
  def change
    create_table :moves do |t|
      t.integer :game_id
      t.integer :from
      t.integer :to
      t.timestamps
    end

    add_index :moves, :game_id
  end
end
