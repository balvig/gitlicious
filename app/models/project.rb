class Project < ActiveRecord::Base
  has_many :commits
  has_many :authors, :through => :commits, :uniq => true
  
  def import_commits!
    git.checkout('master', :force => true)
    git.fetch if git.remotes.size > 0
    git.log(50).each do |commit|
      commits.create(:sha => commit.sha)
    end
  end
  
  def git
    @git ||= Git.open(repo_path)
  end
  
  def current_score(metric)
    commits.order('commited_at DESC').first.send(metric)
  end
  
end
