class Tag < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :name, :scope => :project_id
  before_save :set_build_number, :on => :create
  before_save :set_metrics, :on => :create
  
  def metrics
    {
      :flog => ["flog -s --continue #{project.target_folders}",/([\d\.]+):/],
      :loc  => ['rake stats',/Code LOC: (\d+)/]
    }
  end

  def change
    previous_build = project.tags.order('build_number DESC').where('build_number < ?', build_number).first
    if previous_build && flog.present? &&  previous_build.flog.present?
      flog - previous_build.flog
    else
      0
    end
  end
  
  def reset_metrics!
    metrics.keys.each do |method|
      send("#{method}=",nil)
    end
    set_metrics
    save!
  end

  private
  
  def set_build_number
    self.build_number ||= name[/#{CI_TAG_PREFIX}(\d+)/,1].to_i
  end
    
  def set_metrics
    checkout
    metrics.each do |method,command|
      if send(method).blank?
        output = run(command.first)
        value = output[command.last,1]
        send("#{method}=",value)
      end
    end
    rescue Git::GitExecuteError
  end
  
  def run(command)
    `cd #{project.repo_path} && #{command}`
  end
  
  def checkout
    project.git.checkout(name)
    project.git.lib.send(:command,'submodule update -i') #Submodules not natively supported in ruby-git
  end

end