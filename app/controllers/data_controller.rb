class DataController < ApplicationController
  # GET /data/1
  # GET /data/1.json
  def show
  end

  # POST /data
  # POST /data.json
  def create
    @datum = Datum.new(params[:datum])

    respond_to do |format|
      if @datum.save
        format.html { redirect_to @datum, notice: 'Datum was successfully created.' }
        format.json { render json: @datum, status: :created, location: @datum }
      else
        format.html { render action: "new" }
        format.json { render json: @datum.errors, status: :unprocessable_entity }
      end
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
