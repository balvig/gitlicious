class Metric < ActiveRecord::Base

  DEFAULTS = YAML.load(File.read(Rails.root.join('config','metrics.yml'))).symbolize_keys

  default_scope order('weight DESC')

  def run(project)
    output = project.run(command)
    parse_problems(output)
  end

  private

  def parse_problems(output)
    output.scan(/#{problem_pattern}/).map do |line|
      line = line.first if line.is_a?(Array)
      problem = Problem.new
      problem.metric = self
      problem.line_number = line[/#{line_number_pattern}/,1].to_i
      problem.filename = line[/#{filename_pattern}/,1]
      problem.description = line[/#{description_pattern}/m,1]
      problem
    end
  end
end
