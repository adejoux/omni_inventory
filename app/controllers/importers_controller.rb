class ImportersController < ApplicationController
  before_action :set_importer, only: [:show, :edit, :update, :destroy, :run]

  # GET /importers
  # GET /importers.json
  def index
    @importers = Importer.all
  end

  # GET /importers/1
  # GET /importers/1.json
  def show
  end

  # GET /importers/new
  def new
    @importer = Importer.new
  end

  # GET /importers/1/edit
  def edit
  end

  def run
    @importer.delay.import
    redirect_to importers_path, :flash => { :success => "Import started ! #{view_context.link_to("Imports status", importers_path)}".html_safe }
  end

  def status

  end
  # POST /importers
  # POST /importers.json
  def create
    @importer = Importer.new(importer_params)
    respond_to do |format|

      if @importer.save
        format.html { redirect_to @importer, notice: 'Importer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @importer }
      else
        format.html { render action: 'new' }
        format.json { render json: @importer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /importers/1
  # PATCH/PUT /importers/1.json
  def update
    respond_to do |format|
      if @importer.update(importer_params)
        format.html { redirect_to @importer, notice: 'Importer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @importer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /importers/1
  # DELETE /importers/1.json
  def destroy
    @importer.destroy
    respond_to do |format|
      format.html { redirect_to importers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_importer
      @importer = Importer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def importer_params
      params.require(:importer).permit(:data_dir, :backup_dir, :error_dir, :file_delete, :importer_type, :index_name, :unique_fields_list =>  [])
    end
end
