# frozen_string_literal: true

describe ApplicationMailer, type: :mailer do
  let(:zone) { Zone.create! name: 'Test Zone', time_zone: 'Australia/Brisbane' }
  let(:utc_booking_time) { Time.parse('2021-01-23 00:00:00 UTC') }
  let(:utc_departure_time) { Time.parse('2021-01-28 04:30:00 UTC') }
  let(:traveler) do
    Traveler.create! first_name: 'Donald',
                     last_name: 'Duck',
                     email: 'donald@disney.com',
                     seeding: true
  end
  let(:origin) do
    Location.create! zone_id: zone.id,
                     name: '60 Bristol Street, Hill End, West End',
                     latitude: -27.485823100166996,
                     longitude: 153.0101540219039
  end
  let(:destination) do
    Location.create! zone_id: zone.id,
                     name: 'Riverside Drive, Hill End, Toowong',
                     latitude: -27.486548794319674,
                     longitude: 152.99769662786278
  end

  let(:booking) do
    Timecop.freeze(utc_booking_time) do
      Booking.create! zone_id: zone.id,
                      traveler_id: traveler.id,
                      origin_id: origin.id,
                      destination_id: destination.id,
                      pickup_scheduled_at: utc_departure_time,
                      dropoff_scheduled_at: utc_departure_time + 22.minutes,
                      price: 3.0,
                      seeding: true
    end
  end

  describe '.booking_success' do
    it 'sends a mandrill-mail with the correct variables' do
      Timecop.freeze(utc_booking_time) do
        expect_any_instance_of(ApplicationMailer).to(
          receive(:mandrill_mail)
            .with(template: 'admin-booking-success-au',
                  subject: 'Booking Confirmation',
                  to: { email: traveler.email, name: traveler.first_name },
                  vars: {
                    'FNAME' => traveler.first_name,
                    'LNAME' => traveler.last_name,
                    'ORIGIN' => origin.name,
                    'TRIP_PRICE' => '$1.50',
                    'DATE' => 'Thu 28/01',
                    'TIME' => '14:30 AEST',
                    'BOOKING_DATE' => '23 Jan 2021 10:00 AEST',
                    'PAYMENT_METHOD' => 'Cash'
                  },
                  inline_css: true)
        )

        ApplicationMailer.booking_success(traveler.id, booking.id, 1.5, 'AUD')
      end
    end

    [
      { type: PaymentMethod::CARD, display_name: 'Credit Card' },
      { type: PaymentMethod::CASH, display_name: 'Cash' },
      { type: PaymentMethod::OPALPAY, display_name: 'OpalPay' },
      { type: PaymentMethod::COMP, display_name: 'Complimentary' },
      { type: PaymentMethod::METROCARD, display_name: 'Metrocard' },
      { type: PaymentMethod::OPAL_CONNECT, display_name: 'OpalConnect' }
    ].each do |pm|
      it "formats payment method name for #{pm[:type]}" do
        booking.update!(payment_method: pm[:type])

        expect_any_instance_of(ApplicationMailer).to(
          receive(:mandrill_mail)
            .with(
              template: 'admin-booking-success-au',
              subject: I18n.t('user_mailer.booking_success_subject'),
              to: { email: traveler.email, name: traveler.first_name },
              vars: hash_including(
                'PAYMENT_METHOD' => pm[:display_name]
              ),
              inline_css: true
            )
        )

        ApplicationMailer.booking_success(traveler.id, booking.id, 1.5, 'AUD')
      end
    end
  end

  describe '.cancelled_booking' do
    it 'sends a mandrill-mail with the correct variables' do
      Timecop.freeze(utc_booking_time) do
        expect_any_instance_of(ApplicationMailer).to(
          receive(:mandrill_mail)
            .with(template: 'admin-booking-cancel-au',
                  subject: 'Booking Cancelled',
                  to: { email: traveler.email, name: traveler.first_name },
                  vars: {
                    'FNAME' => traveler.first_name,
                    'LNAME' => traveler.last_name,
                    'ORIGIN' => origin.name,
                    'TRIP_PRICE' => '$3.00',
                    'DATE' => 'Thu 28/01',
                    'TIME' => '14:30 AEST',
                    'BOOKING_DATE' => '23 Jan 2021 10:00 AEST'
                  },
                  inline_css: true)
        )

        ApplicationMailer.cancelled_booking(booking.id)
      end
    end
  end

  describe '.send_welcome_email' do
    it 'sends a mandrill mail with the correct variables' do
      expect_any_instance_of(ApplicationMailer).to(
        receive(:mandrill_mail)
          .with(template: 'admin-welcome-email-au',
                subject: I18n.t('user_mailer.send_welcome_email_subject'),
                to: { email: traveler.email, name: traveler.first_name },
                vars: { 'FNAME' => traveler.first_name },
                inline_css: true)
      )

      ApplicationMailer.send_welcome_email(traveler.id)
    end
  end
end
