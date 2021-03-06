# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  load_resource only: %i[show edit update destroy]
  authorize_resource

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # group by commercial week (1..53)
    @reports = @user.reports.includes(:dogs)
                    .order('walk_date DESC')
                    .group_by { |r| r.walk_date.strftime('%Y / %V') }
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to @user,
                      notice: 'User was successfully created.'
        end
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    successfully_updated = if user_params[:password].present?
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end

    respond_to do |format|
      if successfully_updated
        format.html do
          redirect_to @user,
                      notice: 'User was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/trash
  def trash
    @users = User.only_deleted
  end

  # GET /user/1/put_back
  def put_back
    User.restore(params[:id], recursive: true)
    flash[:notice] = 'Successfully put back'
    redirect_to users_url
  end

  private

  # Never trust parameters from the scary internet,
  #   only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
