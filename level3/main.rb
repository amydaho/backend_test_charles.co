require 'json'
require 'date'
require_relative '../commons/rental_calculator.rb'
require_relative '../commons/data_merger.rb'
require_relative 'commission.rb'

def main
  include DataMerger
  begin
    file = File.open('data/input.json')

    commission = Commission.new
    data = merge_rentals_data(file)
    rentals = []
    result = {}

    data.map do |d|
      res = {}
      h_commission = {}
      rental_calculator = RentalCalculator.new(d["day_count"], d["price_per_day"], d["price_per_km"], d["distance"])
      price = rental_calculator.calculate_total_amount
      decreased_value = rental_calculator.get_decreased_value(price, 30)
      res["id"] = d["id"]
      res["price"] = price
      h_commission["insurance_fee"] = commission.get_insurance_fee(decreased_value)
      h_commission["assistance_fee"] = commission.get_assistance_fee(d["day_count"])
      h_commission["drivy_fee"] = commission.get_drivy_fee(decreased_value, h_commission["insurance_fee"], h_commission["assistance_fee"])
      res["commission"] = h_commission
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