class MissionsController < ApplicationController

  before_action :find_mission, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  after_action :clean_cookies, only: [:index]

  def index
    @q = current_user.missions.ransack(params[:q])
    @missions = @q.result(distinct: true).order(created_at: :asc).page(params[:page]).per(25)
    @expired_missions = current_user.missions.where("end_at <= ?", Time.now).order(end_at: :asc)
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = current_user.missions.new(mission_params)

    if @mission.save
      redirect_to root_path, notice: t("successfully_create_mission")
    else
      render :new
    end
  end

  def show
    if admin?
      @mission = Mission.find(params[:id])
      @user = @mission.user
    else
      @mission = current_user.missions.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: t("cannot_find_mission")
  end

  def edit
  end

  def update
    if @mission.update(mission_params)
      redirect_to root_path, notice: t("successfully_update_mission")
    else
      render :edit
    end
  end

  def destroy
    @mission.destroy
    redirect_to root_path, notice: t("successfully_delete_mission")
  end

  private
  def mission_params
    params.require(:mission).permit(:title, :content, :status, :priority, :start_at, :end_at, { tag_items: [] } )
  end

  def find_mission
    @mission = current_user.missions.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: t("cannot_find_mission")
  end

  def clean_cookies
    cookies[:first_login] = nil
  end

end
