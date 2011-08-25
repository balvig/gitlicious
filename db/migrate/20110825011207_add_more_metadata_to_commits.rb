class AddMoreMetadataToCommits < ActiveRecord::Migration
  def self.up
    add_column :commits, :metrics_log, :text
    add_column :commits, :parent_sha, :string
  end

  def self.down
    remove_column :commits, :parent_sha
    remove_column :commits, :metrics_log
  end
end
