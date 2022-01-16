# frozen_string_literal: true

class ApplicationMailer < MandrillMailer::TemplateMailer
  default from: 'no-reply@bridj.com'

  def booking_success(traveler_id, booking_id, price, currency)
    traveler = Traveler.find(traveler_id)
    booking = Booking.find(booking_id)

    origin = booking.pickup
    time_zone = booking.zone.time_zone

    booking_time = booking.created_at.in_time_zone(time_zone)
    travel_time = booking.pickup_scheduled_at.in_time_zone(time_zone)

    util = Util.new()

    vars = {
      'FNAME' => traveler.first_name,
      'LNAME' => traveler.last_name,
      'ORIGIN' => origin.name,
      'TRIP_PRICE' => util.format_price(price, currency),
      'DATE' => I18n.l(travel_time, format: :trip_list),
      'TIME' => I18n.l(travel_time, format: :time_only),
      'BOOKING_DATE' => I18n.l(booking_time, format: :date_and_time),
      'PAYMENT_METHOD' => util.format_payment_method(booking)
    }

    registering_app = traveler.registering_app
    if registering_app === 'jbird'
      template = 'jbird-booking-confirmed-au'
      subject = 'jbird_mailer.booking_success_subject'
    else
      template = 'admin-booking-success-au'
      subject = 'user_mailer.booking_success_subject'
    end

    mailer = Email.new()
    mailer.send_email(traveler, template, subject, vars)
  end

  def send_welcome_email(traveler_id)
    user = Traveler.find(traveler_id)
    vars = {
      'FNAME' => user.first_name,
      'LNAME' => user.last_name,
    }

    registering_app = user.registering_app
    if registering_app === 'jbird'
      template = 'jbird-welcome-au'
      subject = 'jbird_mailer.send_welcome_email_subject'
    else
      template = 'admin-welcome-email-au'
      subject = 'user_mailer.send_welcome_email_subject'
    end

    mailer = Email.new()
    mailer.send_email(user, template, subject, vars)
  end

  def cancelled_booking(booking_id)
    booking = Booking.find(booking_id)
    traveler = booking.traveler
    price_in_cents = booking.price
    currency = booking.zone.currency
    time_zone = booking.zone.time_zone
    booking_time = booking.created_at
    travel_time = booking.pickup_scheduled_at
    origin = booking.origin.name

    util = Util.new()

    vars = {
      'FNAME' => traveler.first_name,
      'LNAME' => traveler.last_name,
      'ORIGIN' => origin,
      'TRIP_PRICE' => util.format_price(price_in_cents, currency),
      'DATE' => I18n.l(travel_time.in_time_zone(time_zone), format: :trip_list),
      'TIME' => I18n.l(travel_time.in_time_zone(time_zone), format: :time_only),
      'BOOKING_DATE' => I18n.l(booking_time.in_time_zone(time_zone), format: :date_and_time)
    }

    registering_app = traveler.registering_app
    if registering_app === 'jbird'
      template = 'jbird-booking-cancelled-au'
      subject = 'jbird_mailer.cancelled_booking_subject'
    else
      template = 'admin-booking-cancel-au'
      subject = 'user_mailer.cancelled_booking_subject'
    end

    mailer = Email.new()
    mailer.send_email(traveler, template, subject, vars)
  end
end
