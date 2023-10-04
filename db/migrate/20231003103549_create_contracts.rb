class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
