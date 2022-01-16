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

    mandrill_mail(
      template: 'admin-booking-success-au',
      subject: I18n.t('user_mailer.booking_success_subject'),
      to: { email: traveler.email, name: traveler.first_name },
      vars: {
        'FNAME' => traveler.first_name,
        'LNAME' => traveler.last_name,
        'ORIGIN' => origin.name,
        'TRIP_PRICE' => format_price(price, currency),
        'DATE' => I18n.l(travel_time, format: :trip_list),
        'TIME' => I18n.l(travel_time, format: :time_only),
        'BOOKING_DATE' => I18n.l(booking_time, format: :date_and_time),
        'PAYMENT_METHOD' => format_payment_method(booking, traveler)
      },
      inline_css: true
    )
  end

  def format_price(price, currency)
    ActiveSupport::NumberHelper.number_to_currency(price, unit: (currency == 'AUD' ? '$' : currency))
  end

  def format_payment_method(booking, _traveler)
    case booking.payment_method
    when PaymentMethod::CARD
      'Credit Card'
    when PaymentMethod::COMP
      'Complimentary'
    when PaymentMethod::OPALPAY
      'OpalPay'
    else
      booking.payment_method.camelize
    end
  end

  def send_welcome_email(traveler_id)
    user = Traveler.find(traveler_id)

    mandrill_mail(
      template: 'admin-welcome-email-au',
      subject: I18n.t('user_mailer.send_welcome_email_subject'),
      to: { email: user.email, name: user.first_name },
      vars: { 'FNAME' => user.first_name },
      inline_css: true
    )
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

    mandrill_mail(
      template: 'admin-booking-cancel-au',
      subject: I18n.t('user_mailer.cancelled_booking_subject'),
      to: { email: traveler.email, name: traveler.first_name },
      vars: {
        'FNAME' => traveler.first_name,
        'LNAME' => traveler.last_name,
        'ORIGIN' => origin,
        'TRIP_PRICE' => format_price(price_in_cents, currency),
        'DATE' => I18n.l(travel_time.in_time_zone(time_zone), format: :trip_list),
        'TIME' => I18n.l(travel_time.in_time_zone(time_zone), format: :time_only),
        'BOOKING_DATE' => I18n.l(booking_time.in_time_zone(time_zone), format: :date_and_time)
      },
      inline_css: true
    )
  end
end
