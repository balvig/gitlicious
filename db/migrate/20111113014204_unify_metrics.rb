class UnifyMetrics < ActiveRecord::Migration
  def self.up
    require Rails.root.join('db','seeds')
    new_metrics = Metric.where(:project_id => nil)
    Problem.all.each do |p|
      p.metric = new_metrics.where(:name => p.metric.name).first
      p.save!
    end
    Metric.where('project_id IS NOT NULL').destroy_all
  end

  def self.down
  end
end
