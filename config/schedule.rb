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

every :hour do
  runner "Traffic.generate_hourly_records!(Time.zone.now - 1.hour)"
end

every :day do
  runner "Traffic.generate_daily_records!(Time.zone.now - 1.day)"
  runner "Traffic.with_period('minutely').where('start_at < ?', 3.days.ago).destroy_all"
  runner "Traffic.with_period('immediate').where('start_at < ?',  3.days.ago).destroy_all"
end

every :monthly do
  runner "User.all.each(&:recharge)"
end
