require 'spec_helper'

describe "users/index.html.erb" do
   it "should show all the users details" do 
  	assign(:users, 
  		[stub_model(User, :first_name => "michael", 
  											:email => "michael@example.com",
  											:created_at => DateTime.new(2001,2,3)),
  		stub_model(User, 	:first_name => "dave", 
  											:email => "dave@example.com",
  											:created_at => DateTime.new(2010,2,3)),
  		stub_model(User, 	:first_name => "neil", 
  											:email => "neil@example.com",
  											:created_at => DateTime.new(2020,2,3))
  		])
  	render
  	rendered.should include("michael")
  	rendered.should include("signed up 2001-02-03")
  	rendered.should include("dave")
  	rendered.should include("signed up 2010-02-03")
  	rendered.should include("neil")
  	rendered.should include("signed up 2020-02-03")
  	
  end

end
