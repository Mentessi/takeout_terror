require 'spec_helper'

describe ZeroRatingBadge do
  describe "number_of_awards" do   
    let(:badge){ ZeroRatingBadge.new(name: "Zero", description: "zero rated", type: "ZeroRatingBadge") }
    let(:user){ FactoryGirl.create(:user)}

    context "When user has visited one zero rated establishment" do
      before { FactoryGirl.create(:visit, :value_rating_0, user_id: user.id) }   
      it "returns 1" do
        badge.number_of_awards(user).should == 1
      end
    end

    context "When user has visted more than one zero rated establishment" do
      before { FactoryGirl.create(:visit, :value_rating_0, user_id: user.id) } 
      before { FactoryGirl.create(:visit, :value_rating_0, user_id: user.id) }
      it "returns 1" do
        badge.number_of_awards(user).should == 1
      end
    end

    context "When user has not visited any zero rated establishments" do
      before { FactoryGirl.create(:visit, :value_rating_1, user_id: user.id) }
      it "returns 0" do
        badge.number_of_awards(user).should == 0
      end
    end
  end
end
