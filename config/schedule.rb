# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every 1.minute do
  runner "TcpdumpImporter.import_all"
end

every :hour do
  runner "Traffic.generate_hourly_records!(Time.now - 1.hour)"
end

every :day do
  runner "Traffic.generate_daily_records!(Time.now - 1.day)"
  runner "Traffic.minutely.where(:start_at.lt => 3.days.ago).destroy_all"
end

# Learn more: http://github.com/javan/whenever
