class CreateEmissionRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :emission_records do |t|
      t.float :carbon_dioxide, null: false , default: 0
      t.float :air_quality, null: false , default: 0
      t.float :carbon_monoxide, null: false , default: 0
      t.string :devise_id, null: false
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
