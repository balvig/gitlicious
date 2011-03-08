class Tag < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :name, :scope => :project_id
  before_save :set_build_number
  before_save :set_metrics
  
  CI_TAG_PREFIX = 'buildsuccess/master/'
  METRICS = {
    :flog => ['flog -s --continue app/controllers app/helpers app/models lib',/([\d\.]+):/],
    :loc  => ['rake stats',/Code LOC: (\d+)/]
  }
    
  private
  
  def set_build_number
    self.build_number = name[/#{CI_TAG_PREFIX}(\d+)/,1].to_i
  end
    
  def set_metrics
    checkout
    METRICS.each do |method,command|
      output = run(command.first)
      value = output[command.last,1]
      send("#{method}=",value)
    end
  end
  
  def run(command)
    `cd #{project.repo_path} && #{command}`
  end
  
  def checkout
    project.git.checkout(name)
    project.git.lib.send(:command,'submodule update -i') #Submodules not natively supported in ruby-git
  end

end