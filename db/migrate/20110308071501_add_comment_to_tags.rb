class AddCommentToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :comment, :string
  end

  def self.down
    remove_column :tags, :comment
  end
end
