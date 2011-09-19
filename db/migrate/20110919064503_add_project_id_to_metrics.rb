class AddProjectIdToMetrics < ActiveRecord::Migration
  def self.up
    add_column :metrics, :project_id, :integer
  end

  def self.down
    remove_column :metrics, :project_id
  end
end
