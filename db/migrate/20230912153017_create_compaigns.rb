class CreateCompaigns < ActiveRecord::Migration[6.1]
  def change
    create_table :compaigns do |t|
      t.timestamps
    end
  end
end
