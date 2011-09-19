class Metric < ActiveRecord::Base
  
  def run(commit)
    commit.checkout
    output = commit.project.run(command)
    {:log => output, :score => parse_score(output), :problems => parse_problems(output)}
  end
  
  private
  
  def parse_score(output)
    output[/#{score_pattern}/,1].to_f if score_pattern?
  end
  
  def parse_problems(output)
    output.scan(/.+:\d+.+$/).map do |line|
      problem = Problem.new
      problem.line_number = line[/#{line_number_pattern}/,1].to_i
      problem.filename = line[/#{filename_pattern}/,1]
      problem.description = line[/#{description_pattern}/,1]
      problem
    end
  end
end
