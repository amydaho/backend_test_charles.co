module DataMerger
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
end