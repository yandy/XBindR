class PdbsController < ApplicationController
  # GET /pdbs
  # GET /pdbs.json
  def index
    @pdbs = Pdb.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pdbs }
    end
  end

  # GET /pdbs/1
  # GET /pdbs/1.json
  def show
    @pdb = Pdb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pdb }
    end
  end

  # GET /pdbs/new
  # GET /pdbs/new.json
  def new
    @pdb = Pdb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pdb }
    end
  end

  # GET /pdbs/1/edit
  def edit
    @pdb = Pdb.find(params[:id])
  end

  # POST /pdbs
  # POST /pdbs.json
  def create
    @pdb = Pdb.new(params[:pdb])

    respond_to do |format|
      if @pdb.save
        format.html { redirect_to @pdb, notice: 'Pdb was successfully created.' }
        format.json { render json: @pdb, status: :created, location: @pdb }
      else
        format.html { render action: "new" }
        format.json { render json: @pdb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pdbs/1
  # PUT /pdbs/1.json
  def update
    @pdb = Pdb.find(params[:id])

    respond_to do |format|
      if @pdb.update_attributes(params[:pdb])
        format.html { redirect_to @pdb, notice: 'Pdb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pdb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdbs/1
  # DELETE /pdbs/1.json
  def destroy
    @pdb = Pdb.find(params[:id])
    @pdb.destroy

    respond_to do |format|
      format.html { redirect_to pdbs_url }
      format.json { head :no_content }
    end
  end
end
