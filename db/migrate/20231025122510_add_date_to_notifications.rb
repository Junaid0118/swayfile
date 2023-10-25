class AddDateToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :date, :datetime
  end
end
