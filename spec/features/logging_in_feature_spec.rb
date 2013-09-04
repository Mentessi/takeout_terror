require 'spec_helper'

feature "Logging in" do
  before(:each) do
    User.create!( :name => 'Mike Mike',  
                  :email => 'user34@example.com', 
                  :password => 'password',
                  :password_confirmation => 'password')
    User.create!( :name => 'Ted Ted',  
                  :email => 'user50@example.com',
                  :provider => 'facebook',
                  :password => 'password',
                  :password_confirmation => 'password',
                  :uid => '654321')
    User.create!( :name => 'Neil Neil',  
                  :email => 'user40@example.com',
                  :provider => 'google_oauth2',
                  :password => 'password',
                  :password_confirmation => 'password',
                  :uid => '123456')
    visit '/'
    click_link 'Login'
  end

  scenario "with correct credentials" do
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario "with an unrecognized password" do
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Password', :with => 'unrecognized'
    click_button'Sign in'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "as an unrecognized user" do
    fill_in 'Email', :with => 'somebody@anywhere.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "password forgotten" do
    click_link 'Forgot your password?'
    fill_in 'Email', :with => 'user34@example.com'
    click_button 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with instructions about how to reset your password in a few minutes.'
    email = ActionMailer::Base.deliveries.last
    email.to.should == ['user34@example.com']
    email.body.should have_content 'Someone has requested a link to change your password.'
  end

  context "via social media" do
    context "when signed up with email and password" do 
      scenario "with valid credentials" do
        expect(User.count).to eq 3
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :uid => '1234568',
            :info => {
              :nickname => 'MMike',
              :email => 'user34@example.com',
              :name => 'Mike Mike',
              :first_name => 'Mike',
              :last_name => 'Mike',
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
                :id => '1234568',
                :name => 'Mike Mike',
                :first_name => 'Mike',
                :last_name => 'Mike',
                :link => 'http://www.facebook.com/jbloggs',
                :username => 'MMike',
                :location => { :id => '123456789', :name => 'Palo Alto, California' },
                :gender => 'male',
                :email => 'user34@example.com',
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
        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(User.count).to eq 3
      end
    end

    context "when signed up with facebook" do 
      scenario "signing in with valid facebook credentials" do
        expect(User.count).to eq 3
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :uid => '654321',
            :info => {
              :nickname => 'NTed',
              :email => 'user50@example.com',
              :name => 'Ted Ted',
              :first_name => 'Ted',
              :last_name => 'Ted',
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
                :id => '123456',
                :name => 'Ted Ted',
                :first_name => 'Ted',
                :last_name => 'Ted',
                :link => 'http://www.facebook.com/jbloggs',
                :username => 'NTed',
                :location => { :id => '123456789', :name => 'Palo Alto, California' },
                :gender => 'male',
                :email => 'user50@example.com',
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
        expect(page).to have_content 'Successfully authenticated from Facebook account.'
        expect(User.count).to eq 3
      end
    end

    context "when signed up with google_oauth2" do 
      scenario "logging in with valid google credentials" do
        expect(User.count).to eq 3
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
        expect(page).to have_content 'Successfully authenticated from Google account.'
        expect(User.count).to eq 3
      end
    end

    scenario "with INvalid credentials" do
      expect(User.count).to eq 3
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Facebook'
      expect(page).to have_content 'Could not authenticate you from Facebook because'
      expect(User.count).to eq 3
    end
  end
end