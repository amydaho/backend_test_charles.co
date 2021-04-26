require_relative 'data_validator.rb'

##
# This module allows you to format the data of the input file
##
module DataMerger
  include DataValidator

  def convert_file_to_json(file)
    begin
      JSON.parse(file.read)
    rescue JSON::ParserError => e
      puts "File Empty", e
      exit -1
    end
  end

  ##
  # method : Get the options array
  ##
  def options_data(input_data, cars_rentals)
    arr_options = []
    options = input_data[DataValidator::OPTIONS]
    options.map do |option|
      if cars_rentals["id"] == option["rental_id"]
        arr_options << option["type"]
      end
    end
    cars_rentals["options"] = arr_options.length != 0 ? arr_options : []
  end

  def merge_rentals_data(file)
    input_data = convert_file_to_json(file)
    begin
      DataValidator::validate(input_data)
      result = []
      cars = input_data[DataValidator::CARS]
      rentals = input_data[DataValidator::RENTALS]
      rentals.map do |rental|
        day_count = calculate_number_days_between_dates(rental["end_date"], rental["start_date"])
        rental["day_count"] = day_count.to_i + 1
        cars.map do |car|
          if rental["car_id"] == car["id"]
            cars_rentals = car.merge(rental)
            unless input_data[DataValidator::OPTIONS].nil?
              options_data(input_data, cars_rentals)
            end
            result << cars_rentals
          end
        end
      end
      result
    rescue InvalidateRentalsDataError => error
      puts error.message
      exit -1
    end
  end

  private

  def calculate_number_days_between_dates(date1, date2)
    DateTime.parse(date1).to_date - DateTime.parse(date2).to_date
  end

end