# set :output, "/path/to/my/cron_log.log"

every :weekday, :at => '8:30am' do
  rake "reports:create"
end

every :weekday, :at => '5:00pm' do
  rake "reports:create"
end
