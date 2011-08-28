class Project < ActiveRecord::Base
  has_many :commits
  
  def target_folders
    'app/controllers app/helpers app/models lib'
  end
  
  def import_commits!
    git.checkout('master')
    git.fetch if git.branches.remote.size > 0
    git.log(500).each do |commit|
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
