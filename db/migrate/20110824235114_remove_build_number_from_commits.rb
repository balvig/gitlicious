class RemoveBuildNumberFromCommits < ActiveRecord::Migration
  def self.up
    remove_column :commits, :build_number
  end

  def self.down
    add_column :commits, :build_number, :integer
  end
end
