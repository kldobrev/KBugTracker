class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|

      t.belongs_to :from_usr
      t.belongs_to :to_usr
      t.belongs_to :proj
      t.integer :req_type
    end
  end
end
