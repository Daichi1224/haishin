class ApplicationController < ActionController::Base
  def logged_in_user
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください"
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif session[:guest_user]
      @current_user ||= Struct.new(:name, :icon_url).new("ゲスト", nil)
    end
  end

  def logged_in?
    current_user.present?
  end

  helper_method :current_user, :logged_in?
end
