class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.belongs_to :user
      t.string :title, null: false
      t.string :description
      t.integer :prtype, null: false

      t.timestamps null: false
    end
  end
end

