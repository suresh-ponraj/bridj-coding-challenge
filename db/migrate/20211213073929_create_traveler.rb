# frozen_string_literal: true

class CreateTraveler < ActiveRecord::Migration[5.2]
  def change
    create_table :travelers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.timestamps
    end
  end
end
