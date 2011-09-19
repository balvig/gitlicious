class Cleanup < ActiveRecord::Migration
  def self.up
    remove_column :reports, :flog
    remove_column :reports, :loc
    remove_column :reports, :rbp
    remove_column :reports, :comment
    remove_column :reports, :metrics_log
    remove_column :reports, :parent_sha
    remove_column :reports, :author_id
    remove_column :reports, :commited_at
    remove_column :projects, :target_folders
  end

  def self.down
    add_column :reports, :commited_at, :datetime
    add_column :projects, :target_folders, :text, :default => "app/controllers app/helpers app/models lib"
    add_column :reports, :rbp, :integer
    add_column :reports, :author_id, :integer
    add_column :reports, :parent_sha, :string
    add_column :reports, :metrics_log, :text, :default => ""
    add_column :reports, :comment, :string
    add_column :reports, :loc, :integer
    add_column :reports, :flog, :decimal
  end
end
