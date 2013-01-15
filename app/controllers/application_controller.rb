class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def render_query_error msg
    @error = msg
    respond_to do |format|
      format.html { render action: "new" }
      format.json { render json: {error: @error}, status: :unprocessable_entity }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :formats => [:html], :layout => false, :status => :not_found }
      format.json { head :not_found }
    end
  end
end
