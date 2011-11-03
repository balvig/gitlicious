class AddMetricAndReportIdToProblems < ActiveRecord::Migration
  def self.up
    add_column :problems, :metric_id, :integer
    add_column :problems, :report_id, :integer
  end

  def self.down
    remove_column :problems, :report_id
    remove_column :problems, :metric_id
  end
end
