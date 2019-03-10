class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name, limit: 200
      t.string :password
      t.string :salt
      t.datetime :last_deactivated_at
      t.integer :status, default: 1
      t.datetime :deleted_at
      t.integer :user_type, default: 1

      t.timestamps
    end
  end
end
