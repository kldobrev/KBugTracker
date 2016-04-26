class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.belongs_to :project
      t.string :name
      t.integer :administrative

      t.timestamps null: false
    end
  end
end
