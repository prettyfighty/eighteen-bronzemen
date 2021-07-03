class MissionsController < ApplicationController

  before_action :find_mission, only: [:edit, :update, :destroy, :share_mission]
  before_action :authenticate_user!
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
      @mission = current_user.missions.find_by(id: params[:id]) || current_user.shared_missions.find_by!(id: params[:id])
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

  private
  def mission_params
    params.require(:mission).permit(:title, :content, :status, :priority, :start_at, :end_at, { tag_items: [] } )
  end

  def find_mission
    @mission = current_user.missions.joins(:taggings).find_by(id: params[:id]) || current_user.shared_missions.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: t("cannot_find_mission")
  end

  def clean_cookies
    cookies[:first_login] = nil
  end

end
