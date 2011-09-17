class AddRepoUrlToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :repo_url, :string
  end

  def self.down
    remove_column :projects, :repo_url
  end
end
