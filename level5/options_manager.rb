class OptionsManager

  module Options
    GPS = 'gps'
    BABY_SEAT = 'baby_seat'
    ADDITIONAL_INSURANCE = 'additional_insurance'
  end

  def initialize(options = [], day_count)
    @options = options
    @day_count = day_count
  end

  def options_fees()
    result = []
    @options.map do |option|
      if option == Options::GPS
        price = 5 * 100
        result << calculate_fee(price)
      end
      if option == Options::BABY_SEAT
        price = 2 * 100
        result << calculate_fee(price)
      end
      if option == Options::ADDITIONAL_INSURANCE
        price = 10 * 100
        result << calculate_fee(price)
      end
    end
    result
  end

  def check_owner_options
    (@options & [Options::GPS, Options::BABY_SEAT]).any?
  end

  def check_drivy_options
    (@options & [Options::ADDITIONAL_INSURANCE]).any?
  end

  def calculate_fee(price)
    price * @day_count
  end

end