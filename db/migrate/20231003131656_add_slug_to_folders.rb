class AddSlugToFolders < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :slug, :string
  end
end
