class ChangeColumn01 < ActiveRecord::Migration
  def self.up
    change_column :tasks, :title, :text
  end

  def self.down
  end
end
