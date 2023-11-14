class CreateFolderInvitees < ActiveRecord::Migration[6.1]
  def change
    create_table :folder_invitees do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
