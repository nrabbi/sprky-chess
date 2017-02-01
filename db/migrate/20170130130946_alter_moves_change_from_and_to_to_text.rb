class AlterMovesChangeFromAndToToText < ActiveRecord::Migration[5.0]
  def change
    change_column :moves, :from, :text
    change_column :moves, :to, :text
  end
end
