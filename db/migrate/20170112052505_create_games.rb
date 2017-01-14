class CreateGames < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL
      CREATE TYPE status AS ENUM ('created', 'started', 'player 1 won', 'player 2 won', 'draw');
    SQL

    create_table :games do |t|
      t.integer :player_1_id
      t.integer :player_2_id
      t.integer :status, :status
      t.timestamps
    end

    add_index :games, :player_1_id
    add_index :games, :player_2_id
  end

end
