class VehiclesController < ApplicationController
  require 'prawn'
  before_action :authenticate_user!, if: :user_signed_in?
  before_action :authenticate_rto_officer!, only: %i[pending_verification show search], if: :rto_officer_signed_in?
  before_action :set_vehicle, only: %i[show edit update destroy download_emission_records]

  def index
    if user_signed_in?
      @vehicles = Vehicle.all
    elsif rto_officer_signed_in?
      @vehicles = Vehicle.where(status: true).all
    end
  end

  def show
    # Step 1: Fetch and parse the data
    records = @vehicle.emission_records
    data = records.map do |record|
      {
        time: record.created_at.time,
        co2: record.carbon_dioxide,
        co: record.carbon_monoxide,
        air_quality: record.air_quality
      }
    end

    # Step 2: Group the data by minute and capture the highest value
    grouped_data = data.group_by { |record| record[:time].ago(1.minute) }
    highest_values = grouped_data.transform_values do |group|
      {
        co2: group.max_by { |record| record[:co2] }[:co2],
        co: group.max_by { |record| record[:co] }[:co],
        air_quality: group.max_by { |record| record[:air_quality] }[:air_quality]
      }
    end

    # Step 3: Prepare the data for Chartkick
    @chart_data = {
      labels: highest_values.keys.map { |minute| minute.strftime('%Y-%m-%d %H:%M:%S') },
      datasets: [
        { name: 'CO2', data: highest_values.values.map { |record| [record[:time], record[:co2]] } },
        { name: 'CO', data: highest_values.values.map { |record| [record[:time], record[:co]] } },
        { name: 'Air Quality', data: highest_values.values.map { |record| [record[:time], record[:air_quality]] } }
      ]
    }

    @emission_records = records.limit(50)
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
      @vehicle = Vehicle.find_by(vehicle_number: params[:vehicle_number].strip)
    end

    if @vehicle
      redirect_to vehicle_path(@vehicle)
    else
      redirect_to vehicles_path, notice: 'Vehicle not found'
    end
  end

  # Show the list of vehicles that are over polluting the atmosphere

  def approve_vehicle
    @vehicle.update(status: false)

    redirect_to vehicles_path, notice: 'Vehicle approved'
  end

  def download_emission_records
    respond_to do |format|
      format.pdf do
        pdf = EmissionRecordsPdf.new(@vehicle)  # Create the PDF instance
        send_data pdf.render, filename: 'emission_records.pdf', type: 'application/pdf'
      end
    end
  end


  private

  def vehicle_params
    params.require(:vehicle).permit(:vehicle_model, :vehicle_number, :vehicle_type, :status, :devise_id)
  end

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end
