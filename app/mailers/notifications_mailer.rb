class NotificationsMailer < ActionMailer::Base
  default from: "from@example.com"
  default   to: "you@youremail.com"

  def new_message(message)
    @message = message
    mail(:subject => "[YourWebsite.tld] #{message.subject}")
  end

end
