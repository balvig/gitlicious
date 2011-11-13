class RemoveProjectIdFromMetrics < ActiveRecord::Migration
  def self.up
    remove_column :metrics, :project_id
  end

  def self.down
    add_column :metrics, :project_id, :integer
  end
end
