class AddDatetimeToCommits < ActiveRecord::Migration
  def self.up
    add_column :commits, :commited_at, :datetime
  end

  def self.down
    remove_column :commits, :commited_at
  end
end
