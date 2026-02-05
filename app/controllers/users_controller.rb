class UsersController < ApplicationController
  # 1. ログイン前でも「新規登録」だけはできるようにする
  skip_before_action :require_login, only: [:new, :create]

  # 2. 編集・更新・削除の前に「本人確認」と「ゲストお断り」をチェック
  before_action :set_user,       only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :ensure_not_guest, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "ユーザー登録が完了しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # パスワードが空の場合は更新対象から外す（名前だけ変更したい時用）
    update_params = user_params.to_h
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end

    if @user.update(update_params)
      redirect_to root_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    reset_session
    redirect_to login_path, notice: "アカウントを削除しました。ご利用ありがとうございました。", status: :see_other
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  # 対象のユーザーを特定する
  def set_user
    @user = User.find(params[:id])
  end

  # 本人以外の操作をブロック
  def correct_user
    unless current_user == @user
      redirect_to root_path, alert: "権限がありません。"
    end
  end

  # ゲストユーザーの編集・削除を物理的にブロック
  def ensure_not_guest
    if current_user.email == "guest"
      redirect_to root_path, alert: "ゲストユーザーはこの操作を行えません。"
    end
  end
end
