class AddApprovedByToClause < ActiveRecord::Migration[6.0]
  def change
    add_column :clauses, :approved_by, :integer, array: true, default: []
  end
end
