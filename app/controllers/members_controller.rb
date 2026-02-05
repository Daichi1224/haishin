class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy move_up move_down ]

  def index
    u_id = get_current_u_id

    if u_id.present?
      # ログイン中なら、自分のデータだけを出す
      @members = Member.where(user_id: u_id, active: true).order(:position)
    else
      # ログアウト中なら、何も出さない！
      @members = Member.none
    end
  end

  def show
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    @member = Member.new(member_params)
    u_id = get_current_u_id
    @member.user_id = u_id
    @member.active = true
    # 自分のメンバー内での最大positionを取得
    @member.position = (Member.where(user_id: u_id).maximum(:position) || 0) + 1

    if @member.save
      respond_to do |format|
        format.html { redirect_to members_path }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @member.update(member_params)
      redirect_to members_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member.update(active: false)
    respond_to do |format|
      format.html { redirect_to members_path, notice: "削除しました" }
      format.turbo_stream
    end
  end

  def move_up
    u_id = get_current_u_id
    # 自分のメンバーの中から、一つ上の位置の人を探す
    higher_member = Member.where(user_id: u_id, active: true).where("position < ?", @member.position).order(position: :desc).first
    if higher_member
      current_pos = @member.position
      @member.update(position: higher_member.position)
      higher_member.update(position: current_pos)
    end
    redirect_to members_path
  end

  def move_down
    u_id = get_current_u_id
    # 自分のメンバーの中から、一つ下の位置の人を探す
    lower_member = Member.where(user_id: u_id, active: true).where("position > ?", @member.position).order(position: :asc).first
    if lower_member
      current_pos = @member.position
      @member.update(position: lower_member.position)
      lower_member.update(position: current_pos)
    end
    redirect_to members_path
  end

  private

  def set_member
    u_id = get_current_u_id
    # 自分の持ち物以外は絶対に触らせないガード
    @member = Member.where(user_id: u_id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to members_path, alert: "指定されたメンバーが見つかりません。"
  end

  def get_current_u_id
    if defined?(current_user) && current_user.respond_to?(:id) && current_user.present?
      current_user.id
    else
      session[:user_id]
    end
  end

  def member_params
    params.require(:member).permit(:name, :position, :active)
  end
end
