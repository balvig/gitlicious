class Project < ActiveRecord::Base

  has_many :reports, :dependent => :destroy
  has_many :problems, :through => :reports
  has_and_belongs_to_many :authors

  before_create :set_name
  after_create :clone_repository
  after_destroy :remove_repository

  attr_accessible :repo_url, :github_url

  def git
    @git ||= Git.open(repo_path)
  end

  def current_problems
    problems.where(:report_id => reports.latest)
  end

  def run(command)
    Bundler.with_clean_env do
      `cd #{repo_path} && #{command}`
    end
  end

  def current_sha
    update_git_repository
    git.log(1).first.sha
  end

  private

  def set_name
    self.name = repo_url[/^.+[\/:](\w+)(?:\.git)?$/,1]
  end

  def repo_path
    Rails.root.join(Rails.application.config.repo_path, name).to_s
  end

  def clone_repository
    Git.clone(repo_url, repo_path) if repo_url?
  end

  def update_git_repository
    run('git pull') if git.remotes.size > 0 #Not sure why gem git.pull says "up to date"
  end

  def remove_repository
    FileUtils.rm_rf(repo_path)
  end

end
