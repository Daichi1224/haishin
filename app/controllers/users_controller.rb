class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboards_show_path, notice: "ユーザー登録が完了しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました！"
      redirect_to dashboards_show_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    reset_session
    redirect_to signup_path, notice: "アカウントを削除しました。ご利用ありがとうございました。", status: :see_other
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  def correct_user
    @user = User.find(params[:id])
    if !current_user.respond_to?(:id) || current_user.id != @user.id
      redirect_to dashboards_show_path, alert: "権限がありません。"
    end
  end
end
