class RemoveFromAndToTextFromMoves < ActiveRecord::Migration[5.0]
  def change
    remove_column :moves, :from, :text
    remove_column :moves, :to, :text
  end
end
