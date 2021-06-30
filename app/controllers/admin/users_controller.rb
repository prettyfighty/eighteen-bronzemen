class Admin::UsersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_role!

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.includes(:missions).order(id: :asc).page(params[:page]).per(25)
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def check_role!
    redirect_to root_path, notice: t("role_not_admin") if current_user.role != nil
  end
end
