class AddWeightToMetrics < ActiveRecord::Migration
  def self.up
    add_column :metrics, :weight, :decimal, :default => 1
  end

  def self.down
    remove_column :metrics, :weight
  end
end
