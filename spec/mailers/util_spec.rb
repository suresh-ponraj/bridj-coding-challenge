# frozen_string_literal: true

describe Util do
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

    describe '.format_price' do
        it 'formats the price correctly' do
            actual_price = Util.new.format_price(3.0, "AUD")
            expected_price = '$3.00'

            expect(actual_price).to eq(expected_price)
        end
    end

    describe '.format_payment_method' do
        it 'formats the price correctly' do
            actual_format = Util.new.format_payment_method(booking)
            expected_format = 'Cash'

            expect(actual_format).to eq(expected_format)
        end
    end
end
