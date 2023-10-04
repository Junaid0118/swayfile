class AddNameToFolders < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :name, :text
  end
end
