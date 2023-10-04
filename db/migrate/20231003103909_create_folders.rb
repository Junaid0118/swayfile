class CreateFolders < ActiveRecord::Migration[6.1]
  def change
    create_table :folders do |t|

      t.timestamps
    end
  end
end
