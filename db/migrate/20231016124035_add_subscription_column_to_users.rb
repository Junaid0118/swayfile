class AddSubscriptionColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscription, :boolean, default: false
  end
end
