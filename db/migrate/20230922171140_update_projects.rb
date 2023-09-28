class UpdateProjects < ActiveRecord::Migration[6.0]
  def change
    change_table :projects do |t|
      t.string :name
      t.string :project_type
      t.text :description
      t.datetime :date
      t.string :notifications
      t.string :status
    end
  end
end
