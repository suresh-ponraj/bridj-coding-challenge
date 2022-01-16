# frozen_string_literal: true

# == Schema Information
#
# Table name: travelers
#
#  id         :integer          not null, primary key
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Traveler < ApplicationRecord
  attr_accessor :seeding

  after_create :send_welcome_email, unless: :seeding

  private

  def send_welcome_email
    ApplicationMailer.send_welcome_email id
  end
end
