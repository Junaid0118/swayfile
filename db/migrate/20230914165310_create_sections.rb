class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.text :comment
      t.text :description
      t.references :user, null: true, foreign_key: true
      t.references :document, null: true, foreign_key: true

      t.timestamps
    end
  end
end
