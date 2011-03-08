class AddBuildNumberToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :build_number, :integer
  end

  def self.down
    remove_column :tags, :build_number
  end
end
