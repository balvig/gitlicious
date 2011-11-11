class CreateMetrics < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.string :name
      t.text :syntax
      t.string :score_pattern
      t.string :line_number_pattern
      t.string :filename_pattern
      t.string :description_pattern

      t.timestamps
    end
  end

  def self.down
    drop_table :metrics
  end
end
