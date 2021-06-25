class MissionsController < ApplicationController

  before_action :find_mission, only: [:show, :edit, :update, :destroy]

  def index
    @missions = Mission.all
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)

    if @mission.save
      redirect_to root_path, notice: "新增任務成功"
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
      redirect_to root_path, notice: "修改任務成功"
    else
      render :edit
    end
  end

  def destroy
    @mission.delete
    redirect_to root_path, notice: "刪除任務成功"
  end

  private
  def mission_params
    params.require(:mission).permit(:title, :content, :tag, :status, :priority, :start_at, :end_at)
  end

  def find_mission
    @mission = Mission.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: "找不到任務"
  end
end
