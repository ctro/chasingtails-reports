# frozen_string_literal: true

# Clients Controller
class ClientsController < ApplicationController
  load_resource only: %i[show edit update destroy]
  authorize_resource

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all.includes(:dogs).order(:name)
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @reports = @client.reports.includes(:dogs)
                      .order('walk_date DESC')
                      .group_by { |r| Date::MONTHNAMES[r.walk_date.month] }
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html do
          redirect_to @client,
                      notice: 'Client was successfully created.'
        end
        format.json do
          render action: 'show',
                 status: :created, location: @client
        end
      else
        format.html { render action: 'new' }
        format.json do
          render json: @client.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html do
          redirect_to @client,
                      notice: 'Client was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @client.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet,
  #   only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :email, :address)
  end
end
