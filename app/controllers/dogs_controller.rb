# frozen_string_literal: true

# Dog Controller
class DogsController < ApplicationController
  load_and_authorize_resource :client
  load_resource through: :client, only: %i[show edit update destroy]
  authorize_resource

  # before_action :set_client
  # before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index; end

  # renders dog checkboxes for a client.
  def checkboxes
    render partial: 'checkboxes'
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show; end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit; end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        format.html do
          redirect_to @client,
                      notice: 'Dog was successfully created.'
        end
        format.json do
          render action: 'show',
                 status: :created, location: @client
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html do
          redirect_to @client,
                      notice: 'Dog was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to @client }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet,
  #   only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :client_id)
  end
end
