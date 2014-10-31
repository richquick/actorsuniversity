desc "Send email notifications for courses. This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts "Sending reminders..."
  host = ENV["HOST_DOMAIN"]

  if host.blank?
    puts "Environment variable HOST_DOMAIN missing, setting to actorsuniversity.com"
    host = "actorsuniversity.com"  
  end

  Reminder.send_all host
  puts "done."
end
