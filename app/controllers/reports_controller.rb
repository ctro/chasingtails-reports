class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  authorize_resource except: :show

  skip_before_filter :authenticate_user!, only: :show

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all.order("created_at DESC")
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new

    3.times { @report.assets.build }
    @report.walk_date = Date.today
  end

  # GET /reports/1/edit
  def edit
    @report.assets.build
  end

  # POST /reports
  # POST /reports.json
  def create    
    @report = Report.new(report_params)
    @report.user = current_user

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render action: 'show', status: :created, location: @report }
      else
        3.times { @report.assets.build }
        format.html { render action: 'new' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find_by_uuid!(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:client_id, {:dog_ids => []}, 
        :walk_date, :walk_time, :walk_duration, :time, :weather, 
        :recap, :pees, :poops, :energy, :vocalization, :overall,
        assets_attributes: [:picture])
    end
end
