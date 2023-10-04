class AddFolderReferenceToProjects < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :folder, null: true, foreign_key: true
  end
end
