# Coding Challenge - Rails

* Ruby version: 2.3.7
* Project initialisation: `bundle`
* Database creation: `bundle exec rake db:migrate`
* Database seed/reset: `bundle exec rake db:reset`
* How to run the test suite: `rspec` (it should be green on a fresh clone of this repo)

## Initial state
This codebase mimics (in a very simplified way) our legacy mailer. It handles the sending of emails at some critical points in our user flow: user creation, booking, and cancellation.

- `Traveler`: a user of the system
- `Location`: a geographical point with a name
- `Zone`:  a logical grouping of locations, with a time zone and a currency
- `Booking`: a `Traveler` being transported from an origin `Location` to a destination `Location` at a certain time 
- `PaymentMethod`: enum values

The ApplicationMailer has 3 methods used in callbacks: `:send_welcome_email`, `:booking_success`, `:booking_cancellation`
It also uses a 3rd party service called "Mandrill" that has its own API, and requires a template name, and some values for placeholder vars.


## Development Task
We received a request from a client to create a separate booking app for their travelers. The current app is called "Bridj" and the new app is called "J-Bird". The J-Bird app behaves the same as the Bridj app, but sends emails with a different subject and template.

### Acceptance criteria
When a traveler makes a booking using the Bridj app:
- current behavior remains unchanged

When a traveler makes a booking using the J-Bird app:
- welcome emails should have the subject "Welcome to the J-Bird community!", and use "jbird-welcome-au" as a template
- booking confirmation emails should have the subject "Ready to fly!", and use "jbird-booking-confirmed-au" as a template
- booking cancellation emails should have the subject "Cancellation request received", and use "jbird-booking-cancelled-au"


### Expectations for this exercise
For the purpose of this exercise, we do not expect:
- a functioning microservice
- any API work (i.e. endpoints, routes)
- views

We do want to see:
- some way to identify which app a Traveler has used to register (for this exercise, consider `Traveler.create` to be the whole registration flow)
- some sensible refactoring (this code is pretty old, and not very good)
- green specs that demonstrate your changes


## Stretch goals
- The J-Bird app and the Bridj app may each operate in many different zones, but without overlap (each zone may only be used by one app)
- Travelers may sign-in the J-Bird app and the Bridj app with the same credentials. In which case, they receive a welcome email branded with the app they used to register, but subsequent booking confirmation/cancellation emails will be branded depending on the app they used to book that particular trip.
