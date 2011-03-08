class AddCachedMetricsToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :flog, :decimal
    add_column :tags, :loc, :integer
  end

  def self.down
    remove_column :tags, :loc
    remove_column :tags, :flog
  end
end