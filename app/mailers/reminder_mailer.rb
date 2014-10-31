class ReminderMailer < ActionMailer::Base
  default from: 'no-reply@actorsuniversity.com',
          return_path: 'no-reply@actorsuniversity.com'

  def upcoming_courses(host, recipient, course_allocations)
    @host = host
    @recipient = recipient
    @course_allocations = course_allocations

    mail(
      host: host,
      to: recipient.email,
         bcc: ["Email Watcher <watcher@actorsuniversity.com>"])
  end
end
