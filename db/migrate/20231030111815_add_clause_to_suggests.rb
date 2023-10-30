class AddClauseToSuggests < ActiveRecord::Migration[6.1]
  def change
    add_reference :suggests, :clause, null: false, foreign_key: true
  end
end
