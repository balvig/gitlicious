class Metric < ActiveRecord::Base

  belongs_to :project
  has_many :results

  default_scope order('weight DESC')

  def run
    output = project.run(command)
    result = results.build
    result.log = output
    result.problems = parse_problems(output) if problem_pattern?
    result
  end

  private

  def parse_problems(output)
    output.scan(/#{problem_pattern}/).map do |line|
      line = line.first if line.is_a?(Array) #CLEANUP: Huh? I get an array back from multiline ouput
      problem = Problem.new
      problem.line_number = line[/#{line_number_pattern}/,1].to_i
      problem.filename = line[/#{filename_pattern}/,1]
      problem.description = line[/#{description_pattern}/m,1]
      problem
    end
  end
end
