class AddMetricTypeToProblems < ActiveRecord::Migration
  def self.up
    add_column :problems, :metric_type, :string
  end

  def self.down
    remove_column :problems, :metric_type
  end
end
