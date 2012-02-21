class NotificationsMailer < ActionMailer::Base
  default from: "from@vivid-mist-6040.herokuapp.com"
  default   to: "test@heritagepr.org.uk"

  def new_message(message)
    @message = message
    mail(:subject => "[vivid-mist-6040.herokuapp.com] #{message.subject}")
  end

end
