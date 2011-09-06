class Project < ActiveRecord::Base
  has_many :commits
  
  def import_commits!
    git.checkout('master')
    git.pull('origin','master') if git.branches.remote.size > 0
    git.log(10).each do |commit|
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
