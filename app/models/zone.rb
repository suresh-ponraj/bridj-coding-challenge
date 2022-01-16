# frozen_string_literal: true

# == Schema Information
#
# Table name: zones
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  time_zone  :string           default("Australia/Brisbane"), not null
#  currency   :string           default("AUD"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Zone < ApplicationRecord
  has_many :locations
  has_many :bookings
end
