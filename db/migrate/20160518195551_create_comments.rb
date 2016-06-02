class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :defect
      t.belongs_to :user
      t.string :content

      t.timestamps null: false
    end
  end
end
