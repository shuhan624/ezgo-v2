# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "shipment.log"

every 1.hour do
  command "date"
  command "echo 'query package!'"
  rake "shipment:hct:update_packages" #, environment: 'development'
end

# Learn more: http://github.com/javan/whenever
