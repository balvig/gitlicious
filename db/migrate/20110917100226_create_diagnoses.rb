class CreateDiagnoses < ActiveRecord::Migration
  def self.up
    create_table :diagnoses do |t|
      t.integer :commit_id
      t.integer :metric_id
      t.text :log
      t.decimal :score

      t.timestamps
    end
  end

  def self.down
    drop_table :diagnoses
  end
end
