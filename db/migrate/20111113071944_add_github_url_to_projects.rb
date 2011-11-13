class AddGithubUrlToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :github_url, :string
  end

  def self.down
    remove_column :projects, :github_url
  end
end
