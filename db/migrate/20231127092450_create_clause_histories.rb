class CreateClauseHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :clause_histories do |t|
      t.references :clause, null: false, foreign_key: true
      t.string :action
      t.string :before_value
      t.string :after_value

      t.timestamps
    end
  end
end
