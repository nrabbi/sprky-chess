class DropUsersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :users if ActiveRecord::Base.connection.table_exists? :users
  end
end
