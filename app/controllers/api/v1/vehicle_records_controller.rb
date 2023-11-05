module Api
  module V1
    class VehicleRecordsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        @vehicle = Vehicle.find_by(devise_id: emission_record_params['devise_id'])

        if @vehicle.nil?
          # Handle the case where the vehicle is not found, possibly return an error response
          head :not_found
        else
          # Create emission records associated with the vehicle
          @emission_record = @vehicle.emission_records.build(emission_record_params)

          if @emission_record&.save
            if @emission_record.carbon_dioxide > 1200 or @emission_record.carbon_monoxide > 100 or @emission_record.air_quality > 40
              @vehicle.update(status: true )
              UserAlertMailMailer.vehicle_alert(@vehicle).deliver_later
            end
            head :ok
          else
            # Handle the case where an emission record could not be saved, possibly return an error response
            head :unprocessable_entity
          end
        end
      end

      private

      def emission_record_params
        params.require(:emission_record).permit(:carbon_dioxide, :air_quality, :carbon_monoxide, :devise_id)
      end
    end
  end
end
