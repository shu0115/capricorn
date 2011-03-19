class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.string :worker
      t.string :category
      t.string :sub_category
      t.date :start_date
      t.date :due_date
      t.date :complete_date
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
