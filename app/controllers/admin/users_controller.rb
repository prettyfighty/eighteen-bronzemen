class Admin::UsersController < ApplicationController
  http_basic_authenticate_with name: ENV["basic_authenticate_name"], password: ENV["basic_authenticate_password"]

  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_role!

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.includes(:missions).order(id: :asc).page(params[:page]).per(25)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to otrmbklhufma_users_path, notice: t("successfully_create_user")
    else
      render :new
    end
  end

  def show
    @q = @user.missions.ransack(params[:q])
    @missions = @q.result.order(created_at: :asc).page(params[:page]).per(25)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to otrmbklhufma_users_path, notice: t("successfully_update_user")
    else
      render :edit
    end
  end

  def destroy
    @user.delete
    redirect_to otrmbklhufma_users_path, notice: t("successfully_delete_user")
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def check_role!
    redirect_to root_path, notice: t("role_not_admin") unless admin?
  end

end
