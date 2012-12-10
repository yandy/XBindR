class QueryController < ApplicationController

  before_filter :validate_query!, only: :create
  before_filter :get_pdb!, only: :create
  before_filter :get_chains!, only: :create

  def create
    @result = {}
    @chains.each do |ch|
      res_arr = []
      res_status = []
      ch.resdist.each do |rn, fln, dist|
        res_arr << rn
        res_status << (dist < @cutoff ? "+" : "-")
      end
      @result[ch.name] = [res_arr, res_status]
    end
  end

  def show
  end

  protected

  def validate_query!
    @entry_id = params[:entry_id] || ""
    @chain_id = params[:chain_id] || ""
    @cutoff = params[:cutoff].to_i || 0
    return render_query_error "Entry id required!" if @entry_id.empty? || @cutoff <= 0
  end

  def get_pdb!
    @pdb = Pdb.where(entry_id: @entry_id).first
    return render_query_error "PDB not found!" if @pdb.nil?
  end

  def get_chains!
    @chains = @chain_id.empty? ? @pdb.chains : @pdb.chains.where(name: @chain_id)
  end

  def render_query_error msg
    respond_to do |format|
      format.html { render action: "show", notice: msg }
      format.json { render json: {error: msg}, status: :unprocessable_entity }
    end
  end
end
