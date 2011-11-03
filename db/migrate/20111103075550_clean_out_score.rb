class CleanOutScore < ActiveRecord::Migration
  def self.up
    remove_column :reports, :name
    remove_column :metrics, :score_pattern
    remove_column :results, :score
  end

  def self.down
    add_column :results, :score, :decimal, :default => 0.0
    add_column :metrics, :score_pattern, :string
    add_column :reports, :name, :string
  end
end
