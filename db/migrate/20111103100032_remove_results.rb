class RemoveResults < ActiveRecord::Migration
  def self.up
    drop_table :results
  end

  def self.down
    create_table "results", :force => true do |t|
      t.integer  "report_id"
      t.integer  "metric_id"
      t.text     "log"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
