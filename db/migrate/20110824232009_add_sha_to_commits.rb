class AddShaToCommits < ActiveRecord::Migration
  def self.up
    add_column :commits, :sha, :string
  end

  def self.down
    remove_column :commits, :sha
  end
end
