# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id                   :integer          not null, primary key
#  zone_id              :integer          not null
#  traveler_id          :integer          not null
#  origin_id            :integer          not null
#  destination_id       :integer          not null
#  pickup_scheduled_at  :datetime
#  dropoff_scheduled_at :datetime
#  price                :decimal(, )      not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Booking < ApplicationRecord
  belongs_to :zone
  belongs_to :traveler

  belongs_to :origin,
             class_name: 'Location',
             inverse_of: false,
             required: true
  belongs_to :destination,
             class_name: 'Location',
             inverse_of: false,
             required: true

  alias pickup origin
  alias dropoff destination

  attr_accessor :seeding

  after_create :send_confirmation_email, unless: :seeding
  after_destroy :send_cancellation_email

  private

  def send_confirmation_email
    ApplicationMailer.booking_success traveler_id, id, price, zone.currency
  end

  def send_cancellation_email
    ApplicationMailer.cancelled_booking id
  end
end
