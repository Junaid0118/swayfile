class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      drop_table :comments, if_exists: true
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.integer :parent_comment_id, null: true
      t.text :content

      t.timestamps
    end
  end
end
