class MissionsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_mission, only: [:edit, :update, :share_mission]
  after_action :clean_cookies, only: [:index]

  def index
    @q = current_user.missions.ransack(params[:q])
    @missions = @q.result(distinct: true).includes(:tags).order(created_at: :asc).page(params[:page]).per(25)
    @expired_missions = current_user.missions.where("end_at <= ?", Time.now).order(end_at: :asc)
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = current_user.missions.new(mission_params)

    if @mission.save
      redirect_to missions_path, notice: t("successfully_create_mission")
    else
      render :new
    end
  end

  def show
    if admin? || current_user.joined_groups.joins(:missions).merge(Mission.where(id: params[:id])).present?
      @mission = Mission.find(params[:id])
      @user = @mission.user
    else
      @mission = current_user.missions.find_by(id: params[:id]) || current_user.shared_missions.find_by!(id: params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to missions_path, notice: t("mission_not_found")
  end

  def edit
  end

  def update
    if @mission.update(mission_params)
      redirect_to missions_path, notice: t("successfully_update_mission")
    else
      render :edit
    end
  end

  def destroy
    @mission = current_user.missions.find_by!(id: params[:id])
    @mission.destroy
    redirect_to missions_path, notice: t("successfully_delete_mission")
  rescue ActiveRecord::RecordNotFound
    redirect_to missions_path, notice: t("mission_not_found")
  end

  def share_mission
    user = User.find_by(email: params[:email])
    if user && user != current_user
      if @mission.shared_users.exists?(user.id)
        @mission.shared_users.destroy(user)
        render json: { status: "delete", message: I18n.t("successfully_deleted_shared_user") }
      else
        @mission.shared_users << user
        render json: { status: "shared", message: I18n.t("successfully_shared") }
      end
    elsif user == current_user
      render json: { status: "self", message: I18n.t("cannot_self_share") }
    else
      render json: { status: "not_found", message: I18n.t("user_not_found") }
    end
  end

  def shared_mission_list
    @q =current_user.shared_missions.ransack(params[:q])
    @shared_missions = @q.result(distinct: true).includes(:tags, :user).order(created_at: :asc).page(params[:page]).per(25)
  end

  def leave_mission
    mission = Mission.find_by(id: params[:id])
    if mission && current_user.shared_missions.exists?(mission.id)
      current_user.shared_missions.destroy(mission)
      redirect_to missions_path, notice: t("successfully_leaved_mission")
    else
      redirect_to missions_path, notice: t("mission_not_found")
    end
  end

  def share_with_group
    mission = current_user.missions.find_by(id: params[:id])
    group = current_user.joined_groups.find_by(code: params[:code])
    if mission && group
      if group.missions.exists?(mission.id)
        group.missions.destroy(mission)
        render json: { status: "delete", message: I18n.t("successfully_deleted_shared_group") }
      else
        group.missions << mission
        render json: { status: "shared", message: I18n.t("successfully_shared_with_group") }
      end
    else
      render json: { status: "not_found", message: I18n.t("group_not_found") }
    end
  end

  private
  def mission_params
    params.require(:mission).permit(:title, :content, :status, :priority, :start_at, :end_at, { tag_items: [] }, :file)
  end

  def find_mission
    @mission = current_user.missions.find_by(id: params[:id]) || current_user.shared_missions.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to missions_path, notice: t("mission_not_found")
  end

  def clean_cookies
    cookies[:first_login] = nil
  end

end
