class MissionsController < ApplicationController
  http_basic_authenticate_with name: ENV["basic_authenticate_name"], password: ENV["basic_authenticate_password"], except: :index
  before_action :find_mission, only: [:show, :edit, :update, :destroy]

  def index
    # @missions = Mission.order(created_at: :asc)
    @q = Mission.order(created_at: :asc).ransack(params[:q])
    @missions = @q.result
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)

    if @mission.save
      redirect_to root_path, notice: t("successfully_create_mission")
    else
      render :new
    end
  end

  def show
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
    @mission.delete
    redirect_to root_path, notice: t("successfully_delete_mission")
  end

  private
  def mission_params
    params.require(:mission).permit(:title, :content, :tag, :status, :priority, :start_at, :end_at)
  end

  def find_mission
    @mission = Mission.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: t("cannot_find_mission")
  end
end
