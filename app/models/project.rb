class Project < ActiveRecord::Base
  has_many :commits
  
  def target_folders
    'app/controllers app/helpers app/models lib'
  end
  
  def ci_server_url
    "http://192.168.31.237:8080/job/#{name}/"
  end
  
  def import_commits!
    git.fetch if git.branches.remote.size > 0
    git.log.each do |commit|
      commits.create(:sha => commit.sha)
    end
  end
  
  def git
    @git ||= Git.open(repo_path)
  end
  
  def current_score(metric)
    commits.order('build_number DESC').first.send(metric)
  end
  
end
