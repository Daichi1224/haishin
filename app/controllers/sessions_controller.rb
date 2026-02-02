class SessionsController < ApplicationController
  def new
    redirect_to dashboards_show_path if session[:user_id] || session[:guest_user]
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:guest_user] = nil #
      redirect_to dashboards_show_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new
    end
  end

  def guest_create
    session[:guest_user] = true
    session[:user_id] = nil
    redirect_to dashboards_show_path, notice: "ゲストとしてログインしました（データは保存されません）"
  end

  def destroy
    session[:user_id] = nil
    session[:guest_user] = nil
    redirect_to login_path, notice: "ログアウトしました"
  end
end
