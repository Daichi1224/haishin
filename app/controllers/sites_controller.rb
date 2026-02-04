class SitesController < ApplicationController
  before_action :set_site, only: %i[ show edit update destroy ]

  def index
    u_id = nil
    if defined?(current_user) && current_user.respond_to?(:id)
      u_id = current_user.id
    end
    u_id ||= session[:user_id]

    @sites = Site.where(user_id: u_id, active: true).order(:position)
  end

  def show
  end

  def new
    @site = Site.new
  end

  def edit
  end

  def create
    @site = Site.new(site_params)

    u_id = current_user&.id || session[:user_id]
    @site.user_id = u_id
    @site.active = true

    @site.position = (Site.where(user_id: u_id).maximum(:position) || 0) + 1

    respond_to do |format|
      if @site.save
        format.turbo_stream
        format.html { redirect_to sites_path, notice: "現場を登録しました" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        format.turbo_stream
        format.html { redirect_to sites_path, notice: "現場情報を更新しました" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @site.update(active: false)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to sites_path, notice: "現場を非表示にしました" }
    end
  end

  def move_up
    @site = Site.find(params[:id])
    @site.move_higher
    redirect_to sites_path
  end

  def move_down
    @site = Site.find(params[:id])
    @site.move_lower
    redirect_to sites_path
  end

  private

    def set_site
      u_id = current_user&.id || session[:user_id]
      @site = Site.where(user_id: u_id).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to sites_path, alert: "指定された現場が見つかりません。"
    end

    def site_params
      params.require(:site).permit(:name, :user_id, :position, :active)
    end
end
