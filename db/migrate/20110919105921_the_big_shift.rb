class TheBigShift < ActiveRecord::Migration
  def self.up
    rename_table :commits, :reports
    rename_table :diagnoses, :results
    rename_column :results, :commit_id, :report_id
    rename_column :problems, :diagnosis_id, :result_id
    change_column_default :results, :score, 0
  end

  def self.down
    change_column_default :results, :score, nil
    rename_column :problems, :result_id, :diagnosis_id
    rename_column :results, :report_id, :commit_id
    rename_table :results, :diagnoses
    rename_table :reports, :commits
  end
end