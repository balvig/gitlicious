class AddProblemPatternToMetrics < ActiveRecord::Migration
  def self.up
    add_column :metrics, :problem_pattern, :string
  end

  def self.down
    remove_column :metrics, :problem_pattern
  end
end
