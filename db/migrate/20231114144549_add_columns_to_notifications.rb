class AddColumnsToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscription_update, :boolean, default: false
    add_column :users, :project_update, :boolean, default: false
    add_column :users, :pending_actions, :boolean, default: false
  end
end
