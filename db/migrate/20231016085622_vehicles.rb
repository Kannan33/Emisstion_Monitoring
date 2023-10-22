class Vehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_model, null: false
      t.string :vehicle_number, null: false
      t.string :vehicle_type, null: false
      t.string :devise_id, null: false
      t.boolean :status, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
