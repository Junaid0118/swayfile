class AddUserReferenceToClauseHistories < ActiveRecord::Migration[6.1]
  def change
    add_reference :clause_histories, :user, null: false, foreign_key: true
  end
end
