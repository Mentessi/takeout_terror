require 'spec_helper'

feature "Signing up" do

  context "for the first time" do
    scenario "with valid details" do
      visit '/'
      click_link 'Sign up'
      fill_in 'Name', :with => 'John Smith'
      fill_in 'Email', :with => 'user34@example.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully'
    end

    scenario "invalid details are provided" do
      visit '/'
      click_link 'Sign up'
      fill_in 'Name', :with => 'John Smith'
      fill_in 'Email', :with => 'invalid@h'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Sign up'
      expect(page).to have_content '1 error prohibited this user from being saved:'
      expect(page).to have_content 'Email is invalid'
    end
  end


  context "with an email that is already registered" do
    scenario "but with valid details" do
      User.create!( :name => 'Mike Mike', 
                  :email => 'user34@example.com', 
                  :password => 'password',
                  :password_confirmation => 'password')
      visit '/'
      click_link 'Sign up'
      fill_in 'Name', :with => 'John Smith'
      fill_in 'Email', :with => 'user34@example.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Sign up'
      expect(page).to have_content '1 error prohibited this user from being saved:'
      expect(page).to have_content 'Email has already been taken'
    end
  end


  context "via facebook" do
    scenario "with valid credentials" do
      expect(User.count).to eq 0
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '1334567',
          :info => {
            :nickname => 'jbloggs',
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :first_name => 'Joe',
            :last_name => 'Bloggs',
            :image => 'http://graph.facebook.com/1234567/picture?type=square',
            :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
            :location => 'Palo Alto, California',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF', # OAuth 2.0 access_token, which you may wish to store
            :expires_at => 1321747205, # when the access token expires (it always will)
            :expires => true # this will always be true
          },
          :extra => {
            :raw_info => {
              :id => '1234567',
              :name => 'Joe Bloggs',
              :first_name => 'Joe',
              :last_name => 'Bloggs',
              :link => 'http://www.facebook.com/jbloggs',
              :username => 'jbloggs',
              :location => { :id => '123456789', :name => 'Palo Alto, California' },
              :gender => 'male',
              :email => 'joe@bloggs.com',
              :timezone => -8,
              :locale => 'en_US',
              :verified => true,
              :updated_time => '2011-11-11T06:21:03+0000'
            }
          }
      })
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Facebook'
      expect(page).to have_content 'Your account has been created via Facebook. In your profile you can change your personal information and amend your local password from the one we have randomly generated for you.'
      expect(User.count).to eq 1
    end

    scenario "with INvalid credentials" do
      expect(User.count).to eq 0
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Facebook'
      expect(page).to have_content 'Could not authenticate you from Facebook because'
      expect(User.count).to eq 0
    end
  end


  context "via Google" do
    scenario "with valid credentials" do
      expect(User.count).to eq 0
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
          :provider => "google_oauth2",
          :uid => "123456",
          :info => {
              :name => "Neil Neil",
              :email => "user40@example.com",
              :first_name => "Neil",
              :last_name => "Neil",
              :image => "https://lh3.googleusercontent.com/url/photo.jpg"
          },
          :credentials => {
              :token => "token",
              :refresh_token => "another_token",
              :expires_at => 1354920555,
              :expires => true
          },
          :extra => {
              :raw_info => {
                  :id => "123456",
                  :email => "user40@example.com",
                  :verified_email => true,
                  :name => "Neil Neil",
                  :given_name => "Neil",
                  :family_name => "Neil",
                  :link => "https://plus.google.com/123456789",
                  :picture => "https://lh3.googleusercontent.com/url/photo.jpg",
                  :gender => "male",
                  :birthday => "0000-06-25",
                  :locale => "en",
                  :hd => "company_name.com"
              }
          }
      })
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Google Oauth2'
      expect(page).to have_content 'Your account has been created via Google. In your profile you can change your personal information and amend your local password from the one we have randomly generated for you.'
      expect(User.count).to eq 1
    end


    scenario "with INvalid credentials" do
      expect(User.count).to eq 0
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Google Oauth2'
      expect(page).to have_content 'Could not authenticate you from GoogleOauth2 because'
      expect(User.count).to eq 0
    end
  end


  context "signin in for the first time with a new social media oauth provider" do
    scenario "where no email address is returned by omniauth provider" do
      expect(User.count).to eq 0
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '10101010',
          :info => {
            :nickname => 'NNeil',
            :email => '',
            :name => 'Neil Neil',
            :first_name => 'Neil',
            :last_name => 'Neil',
            :image => 'http://graph.facebook.com/1234567/picture?type=square',
            :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
            :location => 'Palo Alto, California',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF', # OAuth 2.0 access_token, which you may wish to store
            :expires_at => 1321747205, # when the access token expires (it always will)
            :expires => true # this will always be true
          },
          :extra => {
            :raw_info => {
              :id => '10101010',
              :name => 'Neil Neil',
              :first_name => 'Neil',
              :last_name => 'Neil',
              :link => 'http://www.facebook.com/jbloggs',
              :username => 'NNeil',
              :location => { :id => '123456789', :name => 'Palo Alto, California' },
              :gender => 'male',
              :email => '',
              :timezone => -8,
              :locale => 'en_US',
              :verified => true,
              :updated_time => '2011-11-11T06:21:03+0000'
            }
          }
      })
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Facebook'
      expect(page).to have_content 'Facebook can not be used to sign-in as they have not provided us with your email address. Please use another authentication provider or use local sign-up.'
      expect(User.count).to eq 0
    end
  end
end