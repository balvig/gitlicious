class SetDefaultMetricsLogToBlank < ActiveRecord::Migration
  def self.up
    change_column_default :commits, :metrics_log, ''
  end

  def self.down
    change_column_default :commits, :metrics_log, nil
  end
end