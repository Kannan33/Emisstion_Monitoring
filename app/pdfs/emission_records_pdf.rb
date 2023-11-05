# require 'prawn'
#
# class EmissionRecordsPdf < Prawn::Document
#   def initialize(vehicle)
#     super()
#     @vehicle = vehicle
#     emission_records_table
#   end
#
#   def emission_records_table
#     data = []
#     data << ["Vehicle Number: #{@vehicle.vehicle_number}"]
#     data << ["Vehicle Model: #{@vehicle.vehicle_model}"]
#     data << ["Vehicle Type: #{@vehicle.vehicle_type}"]
#     data << []  # Add an empty line as a separator
#     data << ['Carbon Dioxide', 'Air Quality', 'Carbon Monoxide', 'Timestamp']
#
#     @vehicle.emission_records.includes(:vehicle).limit(10).each do |emission_record|
#       data << [
#         emission_record.carbon_dioxide,
#         emission_record.air_quality,
#         emission_record.carbon_monoxide,
#         emission_record.created_at.strftime('%Y-%m-%d %H:%M:%S') # Format the timestamp as needed
#       ]
#
#       # Define the column widths
#       column_widths = [100, 100, 100]
#
#       # Create the table headers
#       data[0].each_with_index do |header, index|
#         text header, width: column_widths[index], align: :center, style: :bold
#       end
#
#       data[1..-1].each do |row|
#         row.each_with_index do |cell, index|
#           text cell.to_s, width: column_widths[index], align: :center  # Convert the cell to a string using to_s
#         end
#       end
#     end
#   end
# end
require 'prawn'
require 'prawn/table'
class EmissionRecordsPdf < Prawn::Document
  include Prawn::Table
  def initialize(vehicle)
    super()
    @vehicle = vehicle
    emission_records_table
  end

  def emission_records_table
    data = []
    data << ["Vehicle Number: #{@vehicle.vehicle_number}"]
    data << ["Vehicle Model: #{@vehicle.vehicle_model}"]
    data << ["Vehicle Type: #{@vehicle.vehicle_type}"]
    data << []  # Add an empty line as a separator
    data << ['Carbon Dioxide', 'Air Quality', 'Carbon Monoxide', 'Timestamp']

    @vehicle.emission_records.includes(:vehicle).limit(10).each do |emission_record|
      data << [
        emission_record.carbon_dioxide,
        emission_record.air_quality,
        emission_record.carbon_monoxide,
        emission_record.created_at.strftime('%Y-%m-%d %H:%M:%S') # Format the timestamp as needed
      ]
    end

    # Define the column widths
    column_widths = [100, 100, 100, 150]

    # Create the table
    table(data, header: true, column_widths: column_widths, cell_style: { align: :center }) do
      row(0).font_style = :bold
      row(0).align = :center
      self.header = true
    end
  end
end

# Usage:
# Assuming you have a vehicle object (replace with your actual vehicle object)
# vehicle = Vehicle.find(1)
# pdf = EmissionRecordsPdf.new(vehicle)
# pdf.render_file('emission_records.pdf')
