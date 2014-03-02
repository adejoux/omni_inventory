class ReportsController < ApplicationController
  def index
  end

  def new
    es_mapping = EsMapping.new('servers')
    @collections = es_mapping.mappings
  end

  def  load_fields
    @es_mapping = EsMapping.new('servers', es_type: params[:collection] )
    
    @report=Report.new
    
    respond_to do |format|
      format.json { render :json => {:success => true, :html => (render_to_string(partial: "data_fields", layout: false, :formats => :html ))} }
    end
  end

  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to report_path(@report), notice: 'report was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @report=Report.find(params[:id])

    @report_builder=ReportBuilder.new(@report, page, per_page)
    #@report_builder.set_sort(params[:iSortCol_0].to_i,sort_direction)
    @report_builder.set_search(build_search)
    @columns= @report_builder.columns

    respond_to do |format|
      format.html
      format.json {
        @secho = params[:sEcho].to_i
      }
    end
  end

  private

  def report_params
    params.require(:report).permit(:name, :main_index, :main_index_fields, :parent_index, :parent_index_fields)
  end

  def build_search
    search = {}
    params.select do |key, value|
      if matched = key.match(/sSearch_(\d+)/)
        search[ matched[1] ] = value
      end
    end
    search
  end
end
