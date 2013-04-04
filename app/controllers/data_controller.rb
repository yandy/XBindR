class DataController < ApplicationController

  before_filter :authenticate

  # GET /data/1
  # GET /data/1.json
  def show
  end

  # POST /data
  # POST /data.json
  def create
    Resque.enqueue(DataImporter)

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Task accepted! Data Processing will start later' }
      format.json { render json: @datum, status: :accepted, location: root_url }
    end
  end

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      user = User.authenticate(username, password)
      !!user
    end
  end
end
