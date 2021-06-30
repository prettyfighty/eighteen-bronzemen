class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV["basic_authenticate_name"], password: ENV["basic_authenticate_password"], except: :index

  around_action :set_locale

  helper_method :current_user, :user_signed_in?

  private
  def set_locale(&action)
    if params[:language] && I18n.available_locales.include?( params[:language].to_sym )
      session[:language] = params[:language]
    end
    I18n.with_locale(session[:language] || I18n.default_locale, &action)
  end

  def current_user
    User.find_by(id: session[ENV['session_name']])
  end

  def user_signed_in?
		session[ENV['session_name']]
	end

  def authenticate_user!
    redirect_to sign_in_sessions_path, notice: t("authenticate_user") if session[ENV['session_name']] == nil
  end
end
