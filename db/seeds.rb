# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

zone = Zone.create! name: 'Brisbane'
locations = [
  { name: '60 Bristol Street, Hill End, West End', latitude: -27.485823100166996, longitude: 153.0101540219039 },
  { name: 'Riverside Drive, Hill End, Toowong', latitude: -27.486548794319674, longitude: 152.99769662786278 },
  { name: '63 Hill End Terrace, Hill End, Toowong', latitude: -27.487538636557108, longitude: 152.99707435537132 },
  { name: 'Chelsea Apartments, 42 Dornoch Terrace, Hill End', latitude: -27.487041374300613, longitude: 153.0084803234786 },
  { name: '6 Bristol Street, Hill End, West End', latitude: -27.48528437540466, longitude: 153.0069030588493 },
  { name: '31 Ferry Road, Hill End, Toowong', latitude: -27.48563653587885, longitude: 152.99938214477152 },
  { name: '83 Hardgrave Road, Hill End, West End', latitude: -27.4827682839501, longitude: 153.00688683986667 },
  { name: '44 Corbett Street, Hill End, West End', latitude: -27.48262885881343, longitude: 153.00914538558573 },
  { name: 'Riverclose Apartments, 453 Montague Road', latitude: -27.48795217115197, longitude: 153.0000881943852 },
  { name: '9 Granville Street, Hill End, West End', latitude: -27.483333195617643, longitude: 153.01108730491254 }
].map { |loc| Location.create! loc.merge(zone_id: zone.id) }

traveler = Traveler.create! first_name: 'Donald',
                            last_name: 'Duck',
                            email: 'donald@disney.com',
                            seeding: true
booking = Booking.create zone_id: zone.id,
                         traveler_id: traveler.id,
                         origin_id: locations[0].id,
                         destination_id: locations[1].id,
                         price: 3.0,
                         seeding: true
