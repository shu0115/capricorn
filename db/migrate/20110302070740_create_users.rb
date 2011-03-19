class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login_id
      t.string :hashed_password
      t.string :salt
      t.string :display_name
      t.string :level
      t.string :twitter_id
      t.string :mail_address

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
