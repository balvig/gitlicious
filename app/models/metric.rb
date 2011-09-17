class Metric < ActiveRecord::Base
  
  def run(commit,target_folders)
    commit.run(command(target_folders))
  end
  
  def score_from_log(log)
    log[/#{score_pattern}/,1]
  end
  
  private
  
  def command(target_folders)
    syntax.sub('$FOLDERS',target_folders)
  end
end
