class UsersController < ApplicationController
  #skip_before_action :logged_in_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboards_show_path, notice: "ユーザー登録が完了しました！"
    else
      render :new
    end
  end

  def edit
    if !current_user.respond_to?(:id) || current_user.id.nil?
      redirect_to dashboards_show_path, alert: "ゲストユーザーはプロフィールを編集できません。"
      return
    end
    @user = User.find(params[:id])
  end

  def update
    if !current_user.respond_to?(:id) || current_user.id.nil?
      redirect_to dashboards_show_path, alert: "ゲストユーザーは更新できません。"
      return
    end

    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました！"
      redirect_to dashboards_show_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
