class QueryController < ApplicationController

  before_filter :validate_query!
  before_filter :get_pdb!
  before_filter :get_chains!

  def create
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
