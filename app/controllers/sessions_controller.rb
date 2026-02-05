class SessionsController < ApplicationController
  # ログイン画面、ログイン処理、ゲストログイン処理はログイン前でもアクセスOKにする
  skip_before_action :require_login, only: [:new, :create, :guest_create]

  def new
    # すでにログインしていればダッシュボードへ
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "IDまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def guest_create
    # "guest" というID（email）のユーザーがいれば取得、いなければ作成する
    user = User.find_or_create_by!(email: "guest") do |u|
      u.name = "ゲストユーザー"
      u.password = "password" # 6文字以上のバリデーションに合わせる
      u.password_confirmation = "password"
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: "ゲストとしてログインしました。データは全ユーザーで共有されます。"
  end

  def destroy
    reset_session # セッションを完全にクリア
    redirect_to login_path, notice: "ログアウトしました", status: :see_other
  end
end
