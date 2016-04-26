class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|

      t.belongs_to :user
      t.belongs_to :project

      t.timestamps null: false
    end
  end
end
