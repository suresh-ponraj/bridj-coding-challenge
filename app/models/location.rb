# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  zone_id    :integer          not null
#  name       :string           not null
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Location < ApplicationRecord
  belongs_to :zone
  has_many :bookings_as_origin,
           class_name: 'Booking',
           foreign_key: :origin_id,
           inverse_of: :origin
  has_many :bookings_as_destination,
           class_name: 'Booking',
           foreign_key: :origin_id,
           inverse_of: :destination
end
