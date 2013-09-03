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
end

feature "Signing in" do
  before(:each) do
    User.create!( :name => 'Mike Mike',  
                  :email => 'user34@example.com', 
                  :password => 'password',
                  :password_confirmation => 'password')
  end

  scenario "with correct credentials" do
    visit '/'
    click_link 'Login'
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario "with an unrecognized password" do
    visit '/'
    click_link 'Login'
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Password', :with => 'unrecognized'
    click_button'Sign in'
    expect(page).to have_content 'Invalid email or password'
  end

  scenario "as an unrecognized user" do
    visit '/'
    click_link 'Login'
    fill_in 'Email', :with => 'somebody@anywhere.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email or password'
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

  scenario "with valid details" do
    click_link 'Edit account'
    fill_in 'Email', :with => 'user34@example.com'
    fill_in 'Current password', :with => 'password'
    click_button 'Update'
    expect(page).to have_content 'You updated your account successfully'
  end

  scenario "no password is entered" do
    click_link 'Edit account'
    fill_in 'Email', :with => 'user34@example.com'
    click_button 'Update'
    expect(page).to have_content '1 error prohibited this user from being saved:'
    expect(page).to have_content "Current password can't be blank"
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


