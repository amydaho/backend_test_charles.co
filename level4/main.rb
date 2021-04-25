require 'json'
require 'date'
require_relative '../commons/rental_calculator.rb'
require_relative '../commons/data_merger.rb'
require_relative '../commons/commission.rb'

def main
  include DataMerger
  begin
    file = File.open('data/input.json')

    rentals_data = merge_rentals_data(file)
    rentals = []
    result = {}

    rentals_data.map do |rental|
      res = {}
      rental_calculator = RentalCalculator.new(rental["day_count"], rental["price_per_day"], rental["price_per_km"], rental["distance"])
      price = rental_calculator.calculate_total_amount

      decreased_value = rental_calculator.get_decreased_value(price, 30)

      commission = Commission.new(decreased_value, rental["day_count"])

      res["id"] = rental["id"]
      res["actions"] = commission.get_actions(price)
      rentals << res
    end
    result["rentals"] = rentals
    File.open("data/output.json", "w") { |f| f.write result.to_json }
  rescue Errno::ENOENT => e
    puts "File or directory not found", e
    exit -1
  end
end
main