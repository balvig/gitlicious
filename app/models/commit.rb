class Commit < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :sha, :scope => :project_id
  before_save :set_metrics, :on => :create
  before_save :set_metadata, :on => :create

  def timestamp
    commited_at.to_i * 1000
  end

  def metrics
    {
      :flog => ["flog -s --continue #{project.target_folders}",/([\d\.]+): flog\/method average/],
      :rbp  => ['rails_best_practices .  --without-color',/Found (\d+) errors/]#,
      #:loc  => ['rake stats',/Code LOC: (\d+)/]
    }
  end

  def change(metric)
    if parent && send(metric).present? && parent.send(metric).present?
      send(metric) - parent.send(metric)
    else
      0
    end
  end
  
  def parent
    @parent ||= project.commits.where(:sha => parent_sha).first
  end
  
  def reset_metrics!
    self.metrics_log = ''
    metrics.keys.each do |metric|
      send("#{metric}=",nil)
    end
    set_metrics
    save!
  end
  
  def assessment
    if metrics.keys.all? {|metric|change(metric) < 0 }
      'good'
    elsif metrics.keys.all? {|metric|change(metric) > 0 }
      'bad'
    end
  end

  private
  
  def checkout
    project.git.checkout(sha)
  end
  
  def run(command)
    `cd #{project.repo_path} && #{command}`
  end
  
  def set_metrics
    checkout
    metrics.each do |method,command|
      if send(method).blank?
        output = run(command.first)
        self.metrics_log = "***#{method}***\n\n#{output}\n\n#{metrics_log}"
        value = output[command.last,1]
        send("#{method}=",value) 
      end
    end
    rescue Git::GitExecuteError => e
      logger.error(e)
  end
  
  #\e[31m./app/views/layouts/_tagline.erb:3 - replace instance variable with local variable\e[0m\n\e[31m./
  
  def set_metadata
    metadata = project.git.gcommit(sha)
    self.commited_at = metadata.date
    self.name = metadata.message
    self.parent_sha = metadata.parent.try(:sha)
    rescue Git::GitExecuteError => e
      logger.error(e)
  end

end