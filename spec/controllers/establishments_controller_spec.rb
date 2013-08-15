require 'spec_helper'

describe EstablishmentsController do
  before (:each) do
    @establishment1 = FactoryGirl.create(:establishment)
    @another_establishment = FactoryGirl.create(:establishment, :business_name => "killer kebab")
  end

  describe "GET 'index'" do 
    context "when requesting html format (or no format specified)" do
      before :each do 
        get :index
      end

      specify do
        response.should be_success
      end

      it "renders the establishment index page" do 
        response.should render_template(:index)
      end

      it "finds all the establishments" do
        count = Establishment.count
        count.should == 2
        assigns(:establishments).should == Establishment.all
      end
    end

    context "when requesting json format" do
      it "renders the establishment index page" do
        get :index, :format => :json
        response.should be_success
      end
    end
  end

  describe "GET 'show'" do
    before :each do 
      get :show, :id => @establishment1.id
    end

    specify do
      response.should be_success
    end

    it "finds the right establishment" do 
      assigns(:establishment).should == @establishment1
    end

    it "renders the establishment show page" do 
      response.should render_template(:show) 
    end
  end
end
