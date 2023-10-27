class CreateClauses < ActiveRecord::Migration[6.1]
  def change
    create_table :clauses do |t|
      t.text :content
      t.string :title
      t.references :user
      t.references :project

      t.timestamps
    end
  end
end
