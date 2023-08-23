class ApplicationController < ActionController::Base
  helper_method :current_user
  
  private
  
  def current_user
    @current_user ||= session[:remember_token] && User.find_by_remember_token(session[:remember_token])
  end

  def redirect_back_or(default)
    redirect_to session[:return_to] || default
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
end
