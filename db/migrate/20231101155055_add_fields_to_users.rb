class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :language, :string, default: 'English'
    add_column :users, :address_line_1, :string, default: ''
    add_column :users, :address_line_2, :string, default: ''
    add_column :users, :town, :string, default: ''
    add_column :users, :country, :string, default: 'United States'
    add_column :users, :state, :string, default: ''
    add_column :users, :postal_code, :string, default: ''
    add_column :users, :last_login, :datetime, default: nil
  end
end
