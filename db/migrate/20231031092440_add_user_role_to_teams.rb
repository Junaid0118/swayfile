class AddUserRoleToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :user_role, :string
  end
end
