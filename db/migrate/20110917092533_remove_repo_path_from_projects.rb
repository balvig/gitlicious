class RemoveRepoPathFromProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :repo_path
  end

  def self.down
    add_column :projects, :repo_path, :string
  end
end
