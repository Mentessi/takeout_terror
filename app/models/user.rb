class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook,:google_oauth2]


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
	  find_for_oauth(auth, signed_in_resource=nil)
	end

	def self.find_for_google_oauth2(auth, signed_in_resource=nil)
		find_for_oauth(auth, signed_in_resource=nil)
	end

	def self.find_for_oauth(auth, signed_in_resource=nil)
		User.where(:provider => auth.provider, :uid => auth.uid).first ||
	  User.where(:email => auth[:extra][:raw_info][:email]).first ||
	  User.create( name:auth.extra.raw_info.name,
                 provider:auth.provider,
                 uid:auth.uid,
                 email:auth.info.email,
                 password:Devise.friendly_token[0,20])
	end
	
end
