require 'rest_client'

class LocationsController < ApplicationController
  def ratings
    long = params[:long]
    lat = params[:lat]
    @response_xml = RestClient.get "http://ratings.food.gov.uk/enhanced-search/%5E/%5E/DISTANCE/0/%5E/#{long}/#{lat}/1/1000/json"
    render :inline => @response_xml
  end

  def initial_home
  	render 'initial_home'
  end
end