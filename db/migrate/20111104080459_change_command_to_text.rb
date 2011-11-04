class ChangeCommandToText < ActiveRecord::Migration
  def self.up
    change_column :metrics, :command, :text
  end

  def self.down
    change_column :metrics, :command, :string
  end
end