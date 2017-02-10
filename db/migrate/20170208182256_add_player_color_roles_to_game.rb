class AddPlayerColorRolesToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :player_1_color, :string
    add_column :games, :player_2_color, :string
  end
end
