class ApplicationController < ActionController::Base
  # 全てのアクションの前に「ログインチェック」を強制する
  # (SessionsとUsersコントローラーで一部解除する設定を忘れずに！)
  before_action :require_login

  private

  # 1. ログインしていない人を追い出す門番メソッド
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインが必要です。"
    end
  end

  # 2. 現在のユーザーを特定するメソッド
  def current_user
    # セッションにIDがある場合のみDBを探しに行く
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # 3. ログイン中か判定するメソッド
  def logged_in?
    current_user.present?
  end

  # Viewでもこれらのメソッドを使えるように登録
  helper_method :current_user, :logged_in?
end
