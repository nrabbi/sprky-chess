class AddFromAndToIntegerToMoves < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :restore_from, :integer
    add_column :moves, :restore_to, :integer
  end
end
