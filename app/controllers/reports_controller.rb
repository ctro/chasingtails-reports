# frozen_string_literal: true

# Reports Controller
class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  authorize_resource except: :show

  skip_before_action :authenticate_user!, only: :show

  # GET /reports
  # GET /reports.json
  def index
    # Paginate & eager load
    @reports = Report.includes(:client, :user, :dogs)
                     .order('created_at DESC').paginate(page: params[:page])
  end

  # GET /reports/1
  # GET /reports/1.json
  def show; end

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
        format.html do
          redirect_to @report,
                      notice: 'Report was successfully created.'
        end
        format.json do
          render action: 'show',
                 status: :created, location: @report
        end
      else
        ensure_3_images
        format.html { render action: 'new' }
        format.json do
          render json: @report.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html do
          redirect_to @report,
                      notice: 'Report was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @report.errors,
                 status: :unprocessable_entity
        end
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
    @report = Report.includes(:user, :dogs, :images).find_by!(uuid: params[:id])
  end

  # I'm pretty sure this is all necessary because of a combination of
  #   refile + accepts_nested_attributes_for, and not really using refile's
  #   :multiple option.
  # Multiple option would be great, but it's not supported natively in
  #   android browsers...yet.
  def ensure_3_images
    # cached images stay in params, but HTML does not allow setting value
    #   of file attributes.
    cache_data = begin
                    params[:report][:images_attributes].values
                                                       .map { |i| i['asset'] }
                                                       .reject(&:blank?)
                 rescue StandardError
                   []
                  end

    @cached_images = cache_data.map do |data|
      if data.is_a?(ActionDispatch::Http::UploadedFile)
        # Sometimes this is a Rails Class
        data.original_filename
      else
        # Sometimes it's just JSON, from refile I think.
        JSON.parse(data)['filename']
      end
    end

    # If they haven't cached/saved 3 images yet, then add some
    #   more upload buttons
    total = @cached_images.size
    total += @report.images.size if total.zero?
    (3 - total).times { @report.images.build }
  end

  def report_params
    params.require(:report).permit(:walk_date, :walk_time, :weather,
                                   :recap, :pees, :poops, :energy,
                                   :vocalization, :overall, :walk_duration,
                                   :client_id, :user_id, :no_show,
                                   dog_ids: [], images_attributes: [:asset])
  end
end
