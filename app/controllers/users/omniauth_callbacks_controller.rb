class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook; create; end
  def google_oauth2; create; end
  def twitter; create; end

  PROVIDERS = {
                'facebook'      => 'Facebook', 
                'google_oauth2' => 'Google',
                'twitter'       => 'Twitter'
              }


  def create
    auth = request.env["omniauth.auth"]
    email = auth[:extra][:raw_info][:email]
    provider = auth.provider
    uid = auth.uid
    name = auth.extra.raw_info.name

    # omniauth_identity = OmniauthIdentity.find_by_provider_and_uid(provider, uid)
    omniauth_identity = OmniauthIdentity.where(:provider => provider, :uid => uid).first
    # debugger
    if omniauth_identity
      flash[:notice] = 'Signed in successfully via ' + PROVIDERS[provider] + '.'
      sign_in_and_redirect(:user, omniauth_identity.user)
    else
      if email != ''
        existing_user = User.find_by_email(email)
        if existing_user
          # map this new login method via a service provider to an existing account if the email address is the same
          existing_user.omniauth_identities.create(:provider => provider, :uid => uid)
          flash[:notice] = 'Sign in via ' + PROVIDERS[provider] + ' has been added to your account. Signed in successfully!'
          sign_in_and_redirect(:user, existing_user)
        else
          @provider = provider
          @uid = uid
          @user = User.new(name:name, email:email, password:Devise.friendly_token[0,20])
          begin
            @user.save!  
          rescue ActiveRecord::RecordInvalid
            render 'devise/registrations/new_with_omniauth'
            # redirect_to complete_user_registration_with_omniauth_path
            return
          end
          @user.omniauth_identities.create(:provider => provider, :uid => uid)
          flash[:notice] = 'Your account has been created via ' + PROVIDERS[provider] + '. In your profile you can change your personal information and amend your local password from the one we have randomly generated for you.'
          sign_in_and_redirect(:user, @user)
        end
      else
        flash[:error] = PROVIDERS[provider] + ' can not be used to sign-in as they have not provided us with your email address. Please use another authentication provider or use local sign-up.'
        redirect_to new_user_session_path
      end
    end
  end

  def new_with_omniauth
    email = params[:user][:email]
    name = params[:user][:name]
    @provider = params[:provider]
    @uid = params[:uid]
    
    # find by the email address entered
    # if found create new identity for the found user
    @user = User.find_by_email(email)
    if @user
      # map this new login method via a service provider to an existing account if the email address is the same
      # AND THE PASSWORD ENTERED MATCHES
      @user.omniauth_identities.create(:provider => @provider, :uid => @uid)
      flash[:notice] = 'Sign in via ' + PROVIDERS[@provider] + ' has been added to your account. Signed in successfully!'
      sign_in_and_redirect(:user, @user)
    else
      @user = User.new(name: name, email: email, password: Devise.friendly_token[0,20])
      if @user.save
        @user.omniauth_identities.create(:provider => @provider, :uid => @uid)
        flash[:notice] = 'Your account has been created via ' + PROVIDERS[@provider] + '. In your profile you can change your personal information and amend your local password from the one we have randomly generated for you.'
        sign_in_and_redirect(:user, @user)
      else
        render 'devise/registrations/new_with_omniauth'
      end
    end
  end


private

  def allowed_omniauth_identity_params
    params.require(:omniauth_identity).permit(:user_id, :provider, :uid)
  end

end