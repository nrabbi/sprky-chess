class AlterMovesChangeFromAndToToString < ActiveRecord::Migration[5.0]
  def change
    change_column :moves, :from, :string
    change_column :moves, :to, :string
  end
end
