class CreateSuggests < ActiveRecord::Migration[6.1]
  def change
    create_table :suggests do |t|
      t.string :suggest_type
      t.integer :notify, default: -1
      t.string :status
      t.string :priority
      t.string :comment
      t.integer :user_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
