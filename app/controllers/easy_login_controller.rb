require 'account_controller'
require 'json'

class EasyLoginController < AccountController

  def try_to_login
    user = User.find_by_id(params[:user_id])
    if user.blank? && (Rails.env.development? || Rails.env.staging?)
      flash[:error] = l(:user_not_found)
      redirect_to home_url
    else
      if user.active?
        successful_authentication(user)
      end
    end
  end

  def settings
    @settings ||= Setting.plugin_easy_login
  end

end
