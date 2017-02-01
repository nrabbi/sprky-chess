class RenameRestoreFromAndRestoreToIntegerInMoves < ActiveRecord::Migration[5.0]
  def change
    rename_column :moves, :restore_from, :from
    rename_column :moves, :restore_to, :to
  end
end
