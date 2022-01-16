class AddRegisteringAppToTravelers < ActiveRecord::Migration[5.2]
  def change
    add_column :travelers, :registering_app, :string, null: false, default: 'bridj'
  end
end
