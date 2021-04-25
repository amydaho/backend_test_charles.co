require 'json'
require 'date'

def main
  begin
    file = File.open('data/input.json')

    data = merge_rentals_data(file)
    rentals = []
    data.map do |d|
      res = {}
      price = calculate_price_per_day(d["price_per_day"], d["day_count"]) + calculate_price_per_km(d["price_per_km"], d["distance"])
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

private

def calculate_price_per_day(price_per_day, day_count)
  price_per_day * day_count
end

def calculate_price_per_km(price_per_km, day_count)
  price_per_km * day_count
end

def merge_rentals_data(file)
  begin
    data = JSON.parse(file.read)
    arr = []
    raise NoMethodError, 'key "cars" not found' unless data.key?("cars")
    raise NoMethodError, 'key "rentals" not found' unless data.key?("rentals")
    cars = data["cars"]
    rentals = data["rentals"]
    rentals.map do |x|
      day_count = DateTime.parse(x["end_date"]).to_date - DateTime.parse(x["start_date"]).to_date
      x["day_count"] = day_count.to_i + 1
      cars.map do |y|
        if x["car_id"] == y["id"]
          arr << y.merge(x)
        end
      end
    end
    arr
  end
rescue JSON::ParserError => e
  puts "File Empty"
  exit -1
end

main