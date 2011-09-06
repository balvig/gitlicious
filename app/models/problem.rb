class Problem
  
  attr_accessor :author
  
  def initialize(output)
    @output = output
  end
  
  def line_number
    @output[/:(\d+)/,1].to_i
  end
  
  def filename
    @output[/^(.+):/,1]
  end
  
  def description
    @output[/\s-\s(.+)$/,1]
  end
  
end