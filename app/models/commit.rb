class Commit < ActiveRecord::Base
  belongs_to :project
  belongs_to :author
  has_many :problems
  validates_uniqueness_of :sha, :scope => :project_id
  before_save :set_metrics, :set_metadata, :on => :create
  after_save :create_problems

  scope :recent, order('commited_at DESC')

  def timestamp
    commited_at.to_i * 1000
  end

  def metrics  #TODO: their own model and interface to modify/add new
    {
      :flog => {:command => "flog -s --continue #{project.target_folders}",
                :regexp => /([\d\.]+): flog\/method average/,
                :improvement_when => -1 },
      :rbp  => {:command => 'rails_best_practices .  --without-color',
                :regexp => /Found (\d+) errors/,
                :improvement_when => -1 },
      :loc  => {:command => "countloc -r #{project.target_folders}",
                :regexp => /(\d+)(?=.*\bTOTAL\b)/,
                :improvement_when => 0 }
    }
  end

  def change(metric)
    if parent && send(metric).present? && parent.send(metric).present?
      send(metric) - parent.send(metric)
    else
      0
    end
  end

  def meaning_of_change(metric, difference)
    if metrics[metric][:improvement_when] == 0
      return :no_applies
    end
    normalized_change = difference * metrics[metric][:improvement_when]
    if normalized_change > 0
      return :good
    elsif normalized_change < 0
      return :bad
    else
      return :neutral
    end
  end

  def parent
    @parent ||= project.commits.where(:sha => parent_sha).first
  end

  def reset_metrics!
    self.metrics_log = ''
    metrics.keys.each do |metric|
      send("#{metric}=",nil)
    end
    set_metrics
    save!
  end

  def assessment
    if metrics.keys.all? { |metric|
        meaning_of_change(metric, change(metric)) == :good ||
        meaning_of_change(metric, change(metric)) == :no_applies
      }
      'good'
    elsif metrics.keys.all? { |metric|
        meaning_of_change(metric, change(metric)) == :bad ||
        meaning_of_change(metric, change(metric)) == :no_applies
      }
      'bad'
    end
  end



  private

  def checkout
    project.git.checkout(sha, :force => true)
  end

  def run(command)
    `cd #{project.repo_path} && #{command}`
  end

  def set_metrics
    checkout
    metrics.each do |method,command|
      if send(method).blank?
        output = run(command[:command])
        self.metrics_log = "***#{method}***\n\n#{output}\n\n#{metrics_log}"
        value = output[command[:regexp],1]
        send("#{method}=",value)
      end
    end
    rescue Git::GitExecuteError => e
      logger.error(e)
  end

  def set_metadata
    metadata = project.git.gcommit(sha)
    self.commited_at = metadata.date
    self.name = metadata.message
    self.parent_sha = metadata.parent.try(:sha)
    self.author = Author.find_or_create_from_metadata(metadata.author)
    rescue Git::GitExecuteError => e
      logger.error(e)
  end

  def create_problems
    metrics_log.scan(/(\..+:.+\s-\s.+$)/).map do |results|
      problem = Problem.build_from_log(results.first)
      problem.author = Author.find_or_create_by_name_and_email(blame(problem.filename, problem.line_number))
      problems << problem if problem.author
    end
  end

  def blame(filename, line_number)
    begin
      checkout
      output = project.git.lib.send(:command,"blame #{filename} -L#{line_number},#{line_number} -p")
      return {:name => output[/author\s(.+)$/,1], :email => output[/author-mail\s<(.+)>$/,1]}
    rescue Git::GitExecuteError => e
      logger.error(e)
    end
  end
end
