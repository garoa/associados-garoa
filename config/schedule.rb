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

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']

set :output, { error: 'tmp/error.log', standard: 'tmp/cron.log' }

every :month, at: 'start of the month at 7:00pm' do
  rake "email:monthly_membership"
end

every :month, at: 'start of the month at 1:00am' do
  rake "db:update_users"
end

every :month, at: 'start of the month at 2:00am' do
  rake "db:update_membership_payments"
end
