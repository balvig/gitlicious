class Project < ActiveRecord::Base
  has_many :commits, :dependent => :destroy
  has_many :authors, :through => :commits, :uniq => true
  has_many :metrics
  
  before_create :set_name
  after_create :clone_repository, :create_default_metrics
  after_destroy :remove_repository
  
  accepts_nested_attributes_for :metrics

  def problem_count
    commits.last.try(:problems).try(:count) || 0
  end

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
    end
    result
  end
  
  def supports_rcov?
    metrics.exists?(:name => 'rcov')
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
  
  def create_default_metrics
    metrics.create!( :name                 => 'rails_best_practices',
                    :weight               => 0.5,
                    :command              => 'rails_best_practices --without-color .',
                    :score_pattern        => 'Found (\d+) error',
                    :line_number_pattern  => '^.+:(\d+)',
                    :filename_pattern     => '^\.\/(.+):\d',
                    :description_pattern  => '\s-\s(.+)$'
                  )

    metrics.create!( :name                 => 'cleanup',
                    :weight               => 5,
                    :command              => "grep -r -n '#CLEANUP:' app/controllers app/helpers app/models lib",
                    :line_number_pattern  => '^.+:(\d+)',
                    :filename_pattern     => '^(.+):\d',
                    :description_pattern  => '#CLEANUP:\s(.+)$'
                  )

    metrics.create!( :name                 => 'flog',
                    :command              => 'flog -s --continue app/controllers app/helpers app/models lib',
                    :score_pattern        => '([\d\.]+): flog\/method average'
                  )

    # metrics.create!( :name                 => 'rcov',
    #                 :weight               => 2,
    #                 :command              => "bundle exec rcov -Ispec:lib --gcc --rails --exclude osx\/objc,gems\/,spec\/,features\/,seeds\/ --include views -Ispec ./spec/**/*.rb  --only-uncovered --no-html",
    #                 :line_number_pattern  => '^.+:(\d+)',
    #                 :filename_pattern     => '^(.+):\d',
    #                 :description_pattern  => ':\d+:(.+)$'
    #               )
  end
  
end
