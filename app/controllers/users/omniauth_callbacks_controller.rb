class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook; create; end
  def google_oauth2; create; end

  PROVIDERS = {
                'facebook'      => 'Facebook', 
                'google_oauth2' => 'Google',

              }

  def create
    # You need to implement the method below in the corresponding model (e.g. app/models/user.rb)
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => PROVIDERS[(request.env["omniauth.auth"].provider)]
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end