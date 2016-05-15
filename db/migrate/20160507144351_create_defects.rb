class CreateDefects < ActiveRecord::Migration
  def change
    create_table :defects do |t|

      t.belongs_to :project, index: true
      t.belongs_to :raised_by, index: true
      t.belongs_to :assigned_to, index: true
      t.belongs_to :to_group, index: true
      t.string :title
      t.string :description
      t.integer :status
      t.integer :importance

      t.timestamps null: false
    end
  end
end
