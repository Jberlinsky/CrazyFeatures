class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def ensure_user_authenticated!
    redirect_to controller: :home, action: :unauthenticated unless current_user.present?
  end
end
