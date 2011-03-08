class Tag < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :name, :scope => :project_id
  before_save :set_build_number, :on => :create
  before_save :set_metrics, :on => :create
  
  CI_TAG_PREFIX = 'buildsuccess/master/'
  METRICS = {
    :flog => ['flog -s --continue app/controllers app/helpers app/models lib',/([\d\.]+):/],
    :loc  => ['rake stats',/Code LOC: (\d+)/]
  }

  def score
    previous_build = project.tags.find_by_build_number(build_number-1)
    if previous_build
      flog - previous_build.flog
    else
      0
    end
  end

  private
  
  def set_build_number
    self.build_number ||= name[/#{CI_TAG_PREFIX}(\d+)/,1].to_i
  end
    
  def set_metrics
    checkout
    METRICS.each do |method,command|
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