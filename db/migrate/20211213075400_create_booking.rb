# frozen_string_literal: true

class CreateBooking < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.integer :zone_id, null: false
      t.integer :traveler_id, null: false
      t.integer :origin_id, null: false
      t.integer :destination_id, null: false
      t.datetime :pickup_scheduled_at
      t.datetime :dropoff_scheduled_at
      t.decimal :price, null: false
      t.string :payment_method, null: false, default: PaymentMethod::CASH
      t.timestamps
    end

    add_foreign_key :bookings, to: :zones, column: :zone_id
    add_foreign_key :bookings, to: :travelers, column: :traveler_id
    add_foreign_key :bookings, :locations, column: :origin_id
    add_foreign_key :bookings, :locations, column: :destination_id
  end
end
