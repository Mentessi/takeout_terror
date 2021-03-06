class EstablishmentsController < ApplicationController

  def index
    @establishments = Establishment.all
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @establishments }
    end
  end
  

  def show
    @establishment = Establishment.find(params[:id])
  end

end
