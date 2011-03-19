class AddColumnTasks01 < ActiveRecord::Migration
  def self.up
    add_column :tasks, :status, :string
  end

  def self.down
  end
end
