class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.integer :author_id
      t.integer :commit_id
      t.integer :line_number
      t.string :filename
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :problems
  end
end
