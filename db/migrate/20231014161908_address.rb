class Address < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :area
      t.string :city
      t.string :state
      t.integer :pin_code
      t.references :user, null: false, foreign_key: true
    end
  end
end
