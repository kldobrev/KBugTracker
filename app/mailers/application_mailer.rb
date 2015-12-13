class ApplicationMailer < ActionMailer::Base
  default from: "admin@kbugtracker.com"
  layout 'mailer'
end