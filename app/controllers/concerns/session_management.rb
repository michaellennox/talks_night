# frozen_string_literal: true

module SessionManagement
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  private

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def login(user)
    session[:user_id] = user.id
  end

  def require_login(return_path: home_path)
    return if current_user

    session[:login_return_path] = return_path
    redirect_to new_user_path
  end

  def login_return_path
    session.delete(:login_return_path) || home_path
  end
end
