class AddPendingUsersToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :pending_users, :text, array: true, default: []
  end
end
