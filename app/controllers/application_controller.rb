# Application Controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise
  before_action :authenticate_user!

  # Kinda Lame.
  before_action :set_mailer_host

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def set_mailer_host
    ActionMailer::Base.default_url_options = { host: request.host_with_port }
  end
end
