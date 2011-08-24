class ChangeTagsToCommits < ActiveRecord::Migration
  def self.up
    rename_table :tags, :commits
  end

  def self.down
    rename_table :commits, :tags
  end
end