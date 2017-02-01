class AlterGamesChangeStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :status, :string

    add_index :games, :status
  end
end
