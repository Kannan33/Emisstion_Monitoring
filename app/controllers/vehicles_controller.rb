class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update destroy]

  # if rto officer signed in, they can't edit or create vehicles, only view

  def index

    @vehicles = Vehicle.find_all
  end

  def new
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
  end

  def destroy
  end

  # show the list of vehicles that are over pollute atmosphere

  def vehicles_defected
    # modify this to auto update
    @vehicle = Vehicle.where(status: 1)
    render :index

  end


  private

  def vehicle_params
    params.require(:vehicle).permit(:model_name, :vehicle_number, :vehicle_type, :status)
  end

  def set_vehicle
  end
end