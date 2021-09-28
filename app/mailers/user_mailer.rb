class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def user_notification
    mail(to: params[:recipient],
         body: body_text,
         content_type: 'text/html',
         subject: 'Account Update')
  end

  def body_text
    <<-FOO
      Hi #{params[:recipient].email}

      You have an update on your account.
    FOO
  end
end
