class AddPromoToMoves < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :promo, :string
  end
end
