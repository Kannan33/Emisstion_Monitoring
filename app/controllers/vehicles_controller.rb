class VehiclesController < ApplicationController
  before_action :authenticate_user!, if: :user_signed_in?
  before_action :authenticate_rto_officer!, only: %i[pending_verification show search], if: :rto_officer_signed_in?
  before_action :set_vehicle, only: %i[show edit update destroy]

  # if rto officer signed in, they can't edit or create vehicles, only view

  def index
    @vehicles = Vehicle.all
  end

  def show
    @emission_records = @vehicle.emission_records.limit(10).order(created_at: :desc)
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to vehicles_path
    else
      render :edit
    end
  end

  def create
    @vehicle = Vehicle.create(vehicle_params.merge(user_id: current_user.id))
    if @vehicle.save
      redirect_to vehicles_path, notice: 'Vehicle added successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to vehicles_path, notice: 'Destroyed the vehicle and data'
  end

  def search
    if params[:vehicle_number].present?
      @vehicle = Vehicle.find_by(vehicle_number: params[:vehicle_number])
    end

    if @vehicle
      redirect_to vehicle_path(@vehicle)
    else
      redirect_to vehicles_path, notice: 'Vehicle not found'
    end
  end

  # Show the list of vehicles that are over polluting the atmosphere

  def pending_verification
    @vehicles = Vehicle.where(status: 1)
    render :index
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:vehicle_model, :vehicle_number, :vehicle_type, :status, :devise_id)
  end

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end
