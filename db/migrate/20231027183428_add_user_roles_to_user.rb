class AddUserRolesToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_role, :string
  end
end
