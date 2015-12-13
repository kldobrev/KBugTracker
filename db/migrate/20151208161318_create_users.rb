class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

			t.string :username, null: false
			t.string :email, null: false
			t.string :password_digest, null: false
			t.string :firstname
			t.string :lastname
			t.integer :acctype, null: false
			t.string :act_code
			t.string :ch_pass_code
			
      t.timestamps null: false
    end
  end
end
