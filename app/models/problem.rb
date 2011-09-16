class Problem < ActiveRecord::Base
  
  belongs_to :author
  belongs_to :commit
  
  def self.build_from_log(output)
    problem = Problem.new
    problem.line_number = output[/:(\d+)/,1].to_i
    problem.filename = output[/^(.+):\d/,1]
    problem.description = output[/(\s-\s|#CLEANUP:\s)(.+)$/,2]
    problem
  end
end