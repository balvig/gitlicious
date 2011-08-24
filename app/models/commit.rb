class Commit < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :sha, :scope => :project_id
  before_save :set_metrics, :on => :create
  before_save :set_metadata, :on => :create
    
  def metrics
    {
      :flog => ["flog -s --continue #{project.target_folders}",/([\d\.]+):/],
      :rbp  => ['rails_best_practices .',/Found (\d+) errors/]#,
      #:loc  => ['rake stats',/Code LOC: (\d+)/]
    }
  end

  def change(metric)
    previous_commit = project.commits.order('commited_at DESC').where('commited_at < ?', commited_at).first
    if previous_commit && send(metric).present? && previous_commit.send(metric).present?
      send(metric) - previous_commit.send(metric)
    else
      0
    end
  end
  
  def reset_metrics!
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
    
  def set_metrics
    checkout
    metrics.each do |method,command|
      if send(method).blank?
        output = run(command.first)
        value = output[command.last,1]
        send("#{method}=",value)
      end
    end
    rescue Git::GitExecuteError => e
      logger.error(e)
  end
  
  def run(command)
    `cd #{project.repo_path} && #{command}`
  end
  
  def checkout
    project.git.checkout(sha)
  end
  
  def set_metadata
    metadata = project.git.gcommit(sha)
    self.commited_at = metadata.date
    self.name = metadata.message
    rescue Git::GitExecuteError => e
      logger.error(e)
  end

end