# frozen_string_literal: true

class CreateLocation < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.string :name, null: false
      t.string :time_zone, null: false, default: 'Australia/Brisbane'
      t.string :currency, null: false, default: 'AUD'
      t.timestamps
    end

    create_table :locations do |t|
      t.integer :zone_id, null: false
      t.string :name, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps
    end

    add_foreign_key :locations, :zones
  end
end
