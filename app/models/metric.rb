class Metric < ActiveRecord::Base

  belongs_to :project
  has_many :results

  default_scope order('weight DESC')
  
  def run
    output = project.run(command)
    result = results.build
    result.log = output
    result.problems = parse_problems(output)
    result.score = parse_score(output) || result.problems.size
    result
  end
  
  private
  
  def parse_score(output)
    output[/#{score_pattern}/,1].to_f if score_pattern?
  end
  
  def parse_problems(output)
    output.scan(/^\S.+:\d+.+$/).map do |line|
      problem = Problem.new
      problem.line_number = line[/#{line_number_pattern}/,1].to_i
      problem.filename = line[/#{filename_pattern}/,1]
      problem.description = line[/#{description_pattern}/,1]
      problem
    end
  end
end
