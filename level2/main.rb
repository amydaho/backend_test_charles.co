require 'json'
require 'date'
require_relative 'rental_calculator.rb'
require_relative 'data_merger.rb'


def main
  include DataMerger

  begin
    file = File.open('data/input.json')

    data = merge_rentals_data(file)
    rentals = []

    data.map do |d|
      rental_calculator = RentalCalculator.new(d["day_count"], d["price_per_day"], d["price_per_km"], d["distance"])
      res = {}
      price = rental_calculator.calculate_total_amount
      res["id"] = d["id"]
      res["price"] = price
      rentals << res
    end
    File.open("data/output.json", "w") { |f| f.write rentals.to_json }
  rescue Errno::ENOENT => e
    puts "File or directory not found", e
    exit -1
  end
end


main