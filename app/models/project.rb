class Project < ActiveRecord::Base
  has_many :commits, :dependent => :destroy
  has_many :authors, :through => :commits, :uniq => true
  has_many :metrics
  
  before_create :set_name
  after_create :clone_repository
  after_destroy :remove_repository
  
  accepts_nested_attributes_for :metrics

  def import_commits!
    git.checkout('master', :force => true)
    if git.remotes.size > 0
      git.fetch
      git.pull
    end
    git.log(1).each {|commit|commits.create(:sha => commit.sha)}
  end
  
  def git
    @git ||= Git.open(repo_path)
  end
  
  def current_score
    commits.first.try(:total_score) || 0
  end
  
  def run(command)
    result = ''
    Open4::popen4("sh") do |pid, stdin, stdout, stderr|      
      stdin.puts "unset BUNDLE_GEMFILE"
      stdin.puts "unset RUBYOPT"
      stdin.puts "unset BUNDLE_BIN_PATH"
      stdin.puts "cd #{repo_path}"
      stdin.puts command
      stdin.close
      result = stdout.read.strip
      # puts "stdout     : #{  }"
      # puts "stderr     : #{ stderr.read.strip }"
    end
    result
  end
  
  private
  
  def set_name
    self.name = repo_url[/^.+\/(.+)\.git$/,1]
  end
  
  def repo_path
    Rails.root.join(Rails.application.config.repo_path, name).to_s
  end
  
  def clone_repository
    Git.clone(repo_url, repo_path) if repo_url?
  end
  
  def remove_repository
    FileUtils.rm_rf(repo_path)
  end
  
end
