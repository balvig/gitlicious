class Project < ActiveRecord::Base

  has_many :metrics, :dependent => :destroy
  has_many :reports, :dependent => :destroy
  has_many :problems, :through => :reports
  has_and_belongs_to_many :authors

  before_create :set_name
  after_create :clone_repository, :create_default_metrics
  after_destroy :remove_repository

  accepts_nested_attributes_for :metrics
  attr_accessible :repo_url, :metrics_attributes

  def update_git_repository
    run('git pull') if git.remotes.size > 0 #Not sure why gem git.pull says "up to date"
  end

  def git
    @git ||= Git.open(repo_path)
  end

  def current_problems
    problems.where(:report_id => reports.latest)
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
    end
    result
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

  def remove_repository
    FileUtils.rm_rf(repo_path)
  end

  def create_default_metrics
    Rails.application.config.default_metrics.each do |key, attributes|
      metrics.create!(attributes)
    end
  end

end
