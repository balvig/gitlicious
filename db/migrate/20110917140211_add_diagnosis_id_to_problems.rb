class AddDiagnosisIdToProblems < ActiveRecord::Migration
  def self.up
    add_column :problems, :diagnosis_id, :integer
    rename_column :metrics, :syntax, :command
    remove_column :problems, :commit_id
  end

  def self.down
    add_column :problems, :commit_id, :integer
    rename_column :metrics, :command, :syntax
    remove_column :problems, :diagnosis_id
  end
end
