# frozen_string_literal: true

class Util
    def format_price(price, currency)
      ActiveSupport::NumberHelper.number_to_currency(price, unit: (currency == 'AUD' ? '$' : currency))
    end
  
    def format_payment_method(booking)
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
end
