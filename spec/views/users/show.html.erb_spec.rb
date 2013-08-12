require 'spec_helper'

describe "users/show.html.erb" do
  it "should show a users details" do 
  	assign(:user, stub_model(User, :first_name => "michael", 
  																	:email => "michael@example.com"))
  	render
  	rendered.should include("User: michael")
  	rendered.should include("Email: michael@example.com")
  end
end
