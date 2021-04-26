require 'set'

module DataValidator

  CARS = "cars"
  RENTALS = "rentals"
  OPTIONS = "options"

  def validate(json)
    if json.key?(CARS)
      validate_cars_data(json[CARS])
    else
      raise InvalidateRentalsDataError
    end

    if json.key?(RENTALS)
      validate_rentals_data(json[RENTALS])
    else
      raise InvalidateRentalsDataError
    end

    if json.key?(OPTIONS)
      validate_options(json[OPTIONS])
    end
  end

  def validate_options(options)
    options.each do |option|
      if option.keys == ["id", "rental_id", "type"]
        unless option["type"].is_a? String
          raise InvalidateRentalsDataError
        end
      else
        raise InvalidateRentalsDataError
      end
    end
  end

  private

  def validate_cars_data(cars)
    cars.each do |car|
      if car.keys == ["id", "price_per_day", "price_per_km"]
        if !car["price_per_day"].is_a? Integer or !car["price_per_km"].is_a? Integer
          raise InvalidateRentalsDataError
        end
      else
        raise InvalidateRentalsDataError
      end
    end
  end

  def validate_rentals_data(rentals)
    rentals.each do |rental|
      if rental.keys == ["id", "car_id", "start_date", "end_date", "distance"]
        if !rental["start_date"].is_a? String or !rental["end_date"].is_a? String
          raise InvalidateRentalsDataError
        end
      else
        raise InvalidateRentalsDataError
      end
    end
  end
end

class InvalidateRentalsDataError < StandardError
  def message
    "The json input file you provided is not valid for any calculation related to rentals, commissions or options"
  end
end