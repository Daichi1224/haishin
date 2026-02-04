class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy move_up move_down ]

  def index
    u_id = nil
    if defined?(current_user) && current_user.respond_to?(:id)
      u_id = current_user.id
    elsif session[:user_id]
      u_id = session[:user_id]
    end

    @members = Member.where(user_id: u_id).order(:position)
  end


  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  def edit
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    u_id = nil
    if defined?(current_user) && current_user.respond_to?(:id) && current_user.present?
      u_id = current_user.id
    elsif session[:user_id]
      u_id = session[:user_id]
    end
    @member.user_id = u_id
    @member.active = true

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
      # 自分より一つ上の位置(positionが小さい)の人を探す
      higher_member = Member.where(active: true).where("position < ?", @member.position).order(position: :desc).first
      if higher_member
        # positionの数字を入れ替える
        current_pos = @member.position
        @member.update(position: higher_member.position)
        higher_member.update(position: current_pos)
      end
      redirect_to members_path
    end

    def move_down
      # 自分より一つ下の位置(positionが大きい)の人を探す
      lower_member = Member.where(active: true).where("position > ?", @member.position).order(position: :asc).first
      if lower_member
        current_pos = @member.position
        @member.update(position: lower_member.position)
        lower_member.update(position: current_pos)
      end
      redirect_to members_path
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name)
    end
end
