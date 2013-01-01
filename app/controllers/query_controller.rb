class QueryController < ApplicationController

  before_filter :validate_query!, only: :transaction
  before_filter :get_pdb!, only: :transaction
  before_filter :get_chains!, only: :transaction

  def transaction
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
    @entry_id = (params[:entry_id] || "").downcase
    @chain_id = (params[:chain_id] || "").downcase
    @cutoff = params[:cutoff].to_i || 0
    return render_query_error "PDB id required!" if @entry_id.empty?
    return render_query_error "Illegal PDB id" unless @entry_id =~ /^\w+$/
    return render_query_error "Cutoff required" if @cutoff <= 0
  end

  def get_pdb!
    @pdb = Pdb.where(entry_id: @entry_id).first
    return render_query_error "PDB not found!" if @pdb.nil?
  end

  def get_chains!
    @chains = @chain_id.empty? ? @pdb.chains : @pdb.chains.where(name: @chain_id)
  end

  def render_query_error msg
    @error = msg
    respond_to do |format|
      format.html { render action: "show" }
      format.json { render json: {error: @error}, status: :unprocessable_entity }
    end
  end
end
