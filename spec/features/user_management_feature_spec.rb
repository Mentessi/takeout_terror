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
          :uid => '1234567',
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
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
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
end

feature "Signing in" do
  before(:each) do
    User.create!( :name => 'Mike Mike',  
                  :email => 'user34@example.com', 
                  :password => 'password',
                  :password_confirmation => 'password')
    User.create!( :name => 'Neil Neil',  
                  :email => 'user40@example.com',
                  :provider => 'facebook',
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

  context "via facebook" do
    context "when signed up with email and password" do 
      scenario "with valid credentials" do
        expect(User.count).to eq 2
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
        expect(User.count).to eq 2
      end
    end

    context "when signed up with facebook" do 
      scenario "with valid credentials" do
        expect(User.count).to eq 2
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :uid => '123456',
            :info => {
              :nickname => 'NNeil',
              :email => 'user40@example.com',
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
                :id => '123456',
                :name => 'Neil Neil',
                :first_name => 'Neil',
                :last_name => 'Neil',
                :link => 'http://www.facebook.com/jbloggs',
                :username => 'NNeil',
                :location => { :id => '123456789', :name => 'Palo Alto, California' },
                :gender => 'male',
                :email => 'user40@example.com',
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
        expect(User.count).to eq 2
      end
    end

    scenario "with INvalid credentials" do
      expect(User.count).to eq 2
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit '/'
      click_link 'Sign up'
      click_link 'Sign in with Facebook'
      expect(page).to have_content 'Could not authenticate you from Facebook because'
      expect(User.count).to eq 2
    end
  end
end

feature "Logging Out" do
  before(:each) do
    User.create!( :name => 'Mike Mike', 
                  :email => 'user34@example.com', 
                  :password => 'password',
                  :password_confirmation => 'password')
    visit '/'
    click_link 'Login'
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario "when a user is signed in" do
    click_link 'Logout'
    expect(page).to have_content 'Signed out successfully'
  end
end

feature "Editing account" do
  before(:each) do
    User.create!( :name => 'Mike Mike', 
                  :email => 'user34@example.com', 
                  :password => 'password',
                  :password_confirmation => 'password')
    visit '/'
    click_link 'Login'
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  context "with current password provided" do
    scenario "when changing the email address" do
      click_link 'Edit account'
      fill_in 'Email', :with => 'user34@example.com'
      fill_in 'Current password', :with => 'password'
      click_button 'Update'
      expect(page).to have_content 'You updated your account successfully'
    end
  end

  context "no password is entered" do
    scenario "when changing the email address" do
      click_link 'Edit account'
      fill_in 'Email', :with => 'user36@example.com'
      click_button 'Update'
      expect(page).to have_content '1 error prohibited this user from being saved:'
      expect(page).to have_content "Current password can't be blank"
    end

    scenario "when changing password" do
      click_link 'Edit account'
      fill_in 'Password', :with => 'newpassword'
      fill_in 'Password confirmation', :with => 'newpassword'
      click_button 'Update'
      expect(page).to have_content 'You updated your account successfully.'
    end

    scenario "when changing account fields other than password and email" do
      click_link 'Edit account'
      fill_in 'Name', :with => 'New Name'
      click_button 'Update'
      expect(page).to have_content 'You updated your account successfully.'
    end
  end

  scenario "cancelling account", :js => true do
    click_link 'Edit account'
    click_button 'Cancel my account'
    alert = page.driver.browser.switch_to.alert
    alert.text.should eq("Are you sure?")
    alert.accept
    expect(page).to have_content 'Bye! Your account was successfully cancelled. We hope to see you again soon.'
  end
end


