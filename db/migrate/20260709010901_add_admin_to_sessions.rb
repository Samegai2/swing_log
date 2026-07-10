class AddAdminToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :admin_id, :bigint
    add_index :sessions, :admin_id
    add_foreign_key :sessions, :admins, column: :admin_id
    
    change_column_null :sessions, :user_id, true
  end
end
