require 'spec_helper'

describe Badge do
  
  it "should not be valid with missing attributes" do
    Badge.new(name: "badge1", description: "a new badge").should_not be_valid
    Badge.new(name: "badge1", type: "Badge").should_not be_valid
    Badge.new(description: "a new badge", type: "Badge").should_not be_valid
  end

  describe "number_of_awards" do
    let(:badge) {Badge.new(name: "badge1", description: "a new badge", type: "Badge")}
    let(:user) {FactoryGirl.create(:user)}
    
    specify do
      expect{badge.number_of_awards(user)}.to raise_error(NotImplementedError)
    end
  end


end
