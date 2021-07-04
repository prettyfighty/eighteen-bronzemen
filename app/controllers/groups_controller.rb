class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_group, only: [:edit, :update, :destroy, :destroy_member, :destroy_mission]


  def index
    @q = Group.public_group.ransack(params[:q])
    @groups = @q.result(distinct: true).includes(:user, :members, :missions).order(created_at: :asc).page(params[:page]).per(25)
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      current_user.joined_groups << @group
      redirect_to my_group_groups_path, notice: t("successfully_create_group")
    else
      render :new
    end
  end

  def show
    @group = Group.public_group.find_by(id: params[:id]) || current_user.groups.find_by(id: params[:id]) || current_user.joined_groups.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, notice: t("group_not_found")
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to my_group_groups_path, notice: t("successfully_update_group")
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: t("successfully_delete_group")
  end

  def my_group
    @q = current_user.joined_groups.ransack(params[:q])
    @groups = @q.result(distinct: true).includes(:user, :members, :missions).order(created_at: :asc).page(params[:page]).per(25)
  end

  def join_group
    group = Group.public_group.find(params[:id])
    if group
      if current_user.joined_groups.exists?(group.id)
        redirect_to groups_path, notice: t("already_joined_group")
      else
        current_user.joined_groups << group
        redirect_to groups_path, notice: t("successfully_joined")
      end
    else
      redirect_to groups_path, notice: t("group_not_found")
    end
  end

  def invite_user
    user = User.find_by(email: params[:email])
    group = current_user.joined_groups.find_by(id: params[:id])
    if user && group
      if group.members.exists?(user.id)
        render json: { status: "already", message: I18n.t("user_already_member") }
      else
        group.members << user
        render json: { status: "invited", message: I18n.t("successfully_invited") }
      end
    else
      render json: { status: "not_found", message: I18n.t("user_not_found") }
    end
  end

  def leave_group
    group = Group.find(params[:id])
    if group && current_user.joined_groups.exists?(group.id)
      current_user.joined_groups.destroy(group)
      redirect_to my_group_groups_path, notice: t("successfully_leaved_group")
    else
      redirect_to groups_path, notice: t("group_not_found")
    end
  end

  def destroy_member
    member = @group.members.find_by(id: params[:member_id])
    if member && @group
      @group.members.destroy(member)
      redirect_to group_path(@group), notice: t("successfully_deleted_member")
    else
      redirect_to groups_path, notice: t("user_not_found")
    end
  end

  def destroy_mission
    mission = @group.missions.find_by(id: params[:mission_id])
    if mission && @group
      @group.missions.destroy(mission)
      redirect_to group_path(@group), notice: t("successfully_deleted_mission")
    else
      redirect_to groups_path, notice: t("user_not_found")
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description, :privacy)
  end

  def find_group
    @group = current_user.groups.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, notice: t("group_not_found")
  end


end
