class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :model_name
      t.string :vehicle_number
      t.string :vehicle_type
      t.boolean :status
      t.references :user, null: false, foreign_key: true  # user references

      t.timestamps
    end
  end
end
