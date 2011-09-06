class AddTargetFoldersToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :target_folders, :text, :default => 'app/controllers app/helpers app/models lib'
  end

  def self.down
    remove_column :projects, :target_folders
  end
end
