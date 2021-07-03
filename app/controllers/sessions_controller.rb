class SessionsController < ApplicationController


  def new
    @user = User.new
  end

  def create
    user = User.login(user_params)

    if user
      session[ENV["session_name"]] = user.id
      session[ENV["user_role"]] = user.role
      session[ENV["user_email"]] = user.email
      session[ENV["user_name"]] = user.email[/^\w+/]
      cookies[:first_login] = true

      redirect_to root_path, notice: t("successfully_sign_in")
    else
      redirect_to sign_in_sessions_path, notice: t("email_password_wrong")
    end
  end

  def destroy
    session[ENV["session_name"]] = nil
    session[ENV["user_role"]] = nil
    session[ENV["user_email"]] = nil
    session[ENV["user_name"]] = nil

    redirect_to sign_in_sessions_path, notice: t("successfully_sign_out")
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

end
