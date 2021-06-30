class SessionsController < ApplicationController


  def new
    @user = User.new
  end

  def create
    user = User.login(user_params)

    if user
      # gem install figaro
      session[ENV['session_name']] = user.id

      redirect_to root_path
    else
      redirect_to sign_in_sessions_path, notice: t("email_password_wrong")
    end
  end

  def destroy
    cookies[:return_to_url] = request.referer

    session[ENV['session_name']] = nil
    redirect_to cookies[:return_to_url] || root_path
    cookies[:return_to_url] = nil
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

end
