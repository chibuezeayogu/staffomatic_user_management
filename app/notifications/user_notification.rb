# To deliver this notification:
#
# UserNotification.with(post: @post).deliver_later(current_user)
# UserNotification.with(post: @post).deliver(current_user)

class UserNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database, format: :to_database
  deliver_by :email, mailer: 'UserMailer'
  # deliver_by :actioncable, format: :to_websocket
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :user

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  def url
    Rails.application.routes.url_helper.user_path(params[:user])
  end

  def to_database
    {
      type: self.class.name,
      params: params
    }
  end

  def to_websocket
    {
      message: 'You have an update',
      user: @user
    }
  end

  def user
    @user ||= User.find(params[:id])
  end
end
