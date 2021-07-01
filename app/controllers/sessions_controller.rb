class SessionsController < ApplicationController


  def new
    @user = User.new
  end

  def create
    user = User.login(user_params)

    if user
      session[ENV["user_role"]] = user.role
      session[ENV["user_name"]] = user.email[/^\w+/]
      session[ENV["session_name"]] = user.id

      redirect_to root_path, notice: t("successfully_sign_in")
    else
      redirect_to sign_in_sessions_path, notice: t("email_password_wrong")
    end
  end

  def destroy
    session[ENV["session_name"]] = nil
    redirect_to sign_in_sessions_path, notice: t("successfully_sign_out")
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

end
