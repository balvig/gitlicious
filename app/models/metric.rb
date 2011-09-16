class Metric < ActiveRecord::Base
  def command(folders)
    syntax.sub('$FOLDERS')
  end
end
