class ApplicationController < ActionController::Base

  around_action :set_locale

  def set_locale(&action)
    if params[:language] && I18n.available_locales.include?( params[:language].to_sym )
      session[:language] = params[:language]
    end

    I18n.with_locale(session[:language] || I18n.default_locale, &action)
  end

end
