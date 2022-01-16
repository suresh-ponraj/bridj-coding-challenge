# frozen_string_literal: true

describe Email, type: :mailer do
    let(:zone) { Zone.create! name: 'Test Zone', time_zone: 'Australia/Brisbane' }
    let(:utc_booking_time) { Time.parse('2021-01-23 00:00:00 UTC') }
    let(:utc_departure_time) { Time.parse('2021-01-28 04:30:00 UTC') }
    let(:traveler) do
        Traveler.create! first_name: 'Donald',
                        last_name: 'Duck',
                        email: 'donald@disney.com',
                        seeding: true
    end
    let(:jbird_traveler) do
        Traveler.create! first_name: 'Mickey',
                        last_name: 'Mouse',
                        email: 'mickey@disney.com',
                        seeding: true,
                        registering_app: 'jbird'
    end
    let(:origin) do
        Location.create! zone_id: zone.id,
                        name: '60 Bristol Street, Hill End, West End',
                        latitude: -27.485823100166996,
                        longitude: 153.0101540219039
    end

    describe '.send_email' do
        it 'sends a mandrill-mail for booking success' do
            Timecop.freeze(utc_booking_time) do
                expect_any_instance_of(Email).to(
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
                        inline_css: true
                    )
                )

                Email.send_email(traveler, 'admin-booking-success-au', 'bridj_mailer.booking_success_subject', {
                    'FNAME' => traveler.first_name,
                    'LNAME' => traveler.last_name,
                    'ORIGIN' => origin.name,
                    'TRIP_PRICE' => '$1.50',
                    'DATE' => 'Thu 28/01',
                    'TIME' => '14:30 AEST',
                    'BOOKING_DATE' => '23 Jan 2021 10:00 AEST',
                    'PAYMENT_METHOD' => 'Cash'
                })
            end
        end

        it 'sends a mandrill-mail for booking success using jbird template and subject' do
            Timecop.freeze(utc_booking_time) do
                expect_any_instance_of(Email).to(
                receive(:mandrill_mail)
                    .with(template: 'jbird-booking-confirmed-au',
                        subject: 'Ready to fly!',
                        to: { email: jbird_traveler.email, name: jbird_traveler.first_name },
                        vars: {
                            'FNAME' => jbird_traveler.first_name,
                            'LNAME' => jbird_traveler.last_name,
                            'ORIGIN' => origin.name,
                            'TRIP_PRICE' => '$1.50',
                            'DATE' => 'Thu 28/01',
                            'TIME' => '14:30 AEST',
                            'BOOKING_DATE' => '23 Jan 2021 10:00 AEST',
                            'PAYMENT_METHOD' => 'Cash'
                        },
                        inline_css: true
                    )
                )

                Email.send_email(jbird_traveler, 'jbird-booking-confirmed-au', 'jbird_mailer.booking_success_subject', {
                    'FNAME' => jbird_traveler.first_name,
                    'LNAME' => jbird_traveler.last_name,
                    'ORIGIN' => origin.name,
                    'TRIP_PRICE' => '$1.50',
                    'DATE' => 'Thu 28/01',
                    'TIME' => '14:30 AEST',
                    'BOOKING_DATE' => '23 Jan 2021 10:00 AEST',
                    'PAYMENT_METHOD' => 'Cash'
                })
            end
        end

        it 'sends a mandrill-mail for booking cancellation' do
            Timecop.freeze(utc_booking_time) do
                expect_any_instance_of(Email).to(
                receive(:mandrill_mail)
                    .with(template: 'admin-booking-cancel-au',
                        subject: 'Booking Cancelled',
                        to: { email: traveler.email, name: traveler.first_name },
                        vars: {
                            'FNAME' => traveler.first_name,
                            'LNAME' => traveler.last_name,
                            'ORIGIN' => origin.name,
                            'TRIP_PRICE' => '$1.50',
                            'DATE' => 'Thu 28/01',
                            'TIME' => '14:30 AEST',
                            'BOOKING_DATE' => '23 Jan 2021 10:00 AEST'
                        },
                        inline_css: true
                    )
                )

                Email.send_email(traveler, 'admin-booking-cancel-au', 'bridj_mailer.cancelled_booking_subject', {
                    'FNAME' => traveler.first_name,
                    'LNAME' => traveler.last_name,
                    'ORIGIN' => origin.name,
                    'TRIP_PRICE' => '$1.50',
                    'DATE' => 'Thu 28/01',
                    'TIME' => '14:30 AEST',
                    'BOOKING_DATE' => '23 Jan 2021 10:00 AEST',
                })
            end
        end

        it 'sends a mandrill-mail for booking cancellation using jbird template and subject' do
            Timecop.freeze(utc_booking_time) do
                expect_any_instance_of(Email).to(
                receive(:mandrill_mail)
                    .with(template: 'jbird-booking-cancelled-au',
                        subject: 'Cancellation request received',
                        to: { email: jbird_traveler.email, name: jbird_traveler.first_name },
                        vars: {
                            'FNAME' => jbird_traveler.first_name,
                            'LNAME' => jbird_traveler.last_name,
                            'ORIGIN' => origin.name,
                            'TRIP_PRICE' => '$1.50',
                            'DATE' => 'Thu 28/01',
                            'TIME' => '14:30 AEST',
                            'BOOKING_DATE' => '23 Jan 2021 10:00 AEST'
                        },
                        inline_css: true
                    )
                )

                Email.send_email(jbird_traveler, 'jbird-booking-cancelled-au', 'jbird_mailer.cancelled_booking_subject', {
                    'FNAME' => jbird_traveler.first_name,
                    'LNAME' => jbird_traveler.last_name,
                    'ORIGIN' => origin.name,
                    'TRIP_PRICE' => '$1.50',
                    'DATE' => 'Thu 28/01',
                    'TIME' => '14:30 AEST',
                    'BOOKING_DATE' => '23 Jan 2021 10:00 AEST',
                })
            end
        end

        it 'sends a mandrill-mail for welcoming' do
            Timecop.freeze(utc_booking_time) do
                expect_any_instance_of(Email).to(
                receive(:mandrill_mail)
                    .with(template: 'admin-welcome-email-au',
                        subject: 'Welcome to the Bridj family!',
                        to: { email: traveler.email, name: traveler.first_name },
                        vars: {
                            'FNAME' => traveler.first_name,
                            'LNAME' => traveler.last_name
                        },
                        inline_css: true
                    )
                )

                Email.send_email(traveler, 'admin-welcome-email-au', 'bridj_mailer.send_welcome_email_subject', vars = {
                    'FNAME' => traveler.first_name,
                    'LNAME' => traveler.last_name,
                })
            end
        end

        it 'sends a mandrill-mail for welcoming using jbird template and subject' do
            Timecop.freeze(utc_booking_time) do
                expect_any_instance_of(Email).to(
                receive(:mandrill_mail)
                    .with(template: 'jbird-welcome-au',
                        subject: 'Welcome to the J-Bird community!',
                        to: { email: jbird_traveler.email, name: jbird_traveler.first_name },
                        vars: {
                            'FNAME' => jbird_traveler.first_name,
                            'LNAME' => jbird_traveler.last_name
                        },
                        inline_css: true
                    )
                )

                Email.send_email(jbird_traveler, 'jbird-welcome-au', 'jbird_mailer.send_welcome_email_subject', vars = {
                    'FNAME' => jbird_traveler.first_name,
                    'LNAME' => jbird_traveler.last_name,
                })
            end
        end
    end
end
