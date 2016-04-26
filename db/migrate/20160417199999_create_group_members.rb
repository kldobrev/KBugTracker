class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members, id: false do |t|

      t.belongs_to :group, index: true
      t.belongs_to :member, index: true

      t.timestamps null: false
    end
  end
end
