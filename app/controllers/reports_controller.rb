class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  authorize_resource except: :show

  skip_before_filter :authenticate_user!, only: :show

  # GET /reports
  # GET /reports.json
  def index
    # Paginate & eager load
    @reports = Report.includes(:client, :user, :dogs)
      .order("created_at DESC").paginate(:page => params[:page])
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
    ensure_3_images
    @report.walk_date = Time.zone.now
  end

  # GET /reports/1/edit
  def edit
    ensure_3_images
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

    def set_report
      @report = Report.includes(:user, :dogs, :images).find_by_uuid!(params[:id])
    end

    def ensure_3_images
      # don't need to "build" if there is an image present -- it gets its own ChooseFile button automatically.
      (3 - @report.images.count).times {@report.images.build}
    end

    def report_params
      # Quit forking with strong params, users are authenticated!
      params.require(:report).permit!
    end
end
