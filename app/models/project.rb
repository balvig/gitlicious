class Project < ActiveRecord::Base
  has_many :commits, :dependent => :destroy
  has_many :authors, :through => :commits, :uniq => true
  
  after_create :clone_repository
  after_destroy :remove_repository
  
  def import_commits!
    git.checkout('master', :force => true)
    if git.remotes.size > 0
      git.fetch
      git.pull
    end
    git.log(50).each {|commit|commits.create(:sha => commit.sha)}
  end
  
  def git
    @git ||= Git.open(repo_path)
  end
  
  def current_score(metric)
    commits.order('commited_at DESC').first.send(metric)
  end
  
  def run(command)
    `cd #{repo_path} && #{command}`
  end
  
  private
  
  def repo_path
    Rails.root.join('repos', name).to_s
  end
  
  def clone_repository
    Git.clone(repo_url, repo_path) if repo_url?
  end
  
  def remove_repository
    FileUtils.rm_rf(repo_path)
  end
  
end
