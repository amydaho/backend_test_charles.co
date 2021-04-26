require 'minitest/autorun'
require_relative 'main.rb'
require 'minitest/spec'


describe main do

  let(:price_per_day) { 2000 }
  let(:price_per_km) { 10 }
  let(:total_days) { 1 }
  let(:distance) { 100 }
  let(:percent) { 10 }
  let(:option) { ["gps", "baby_seat"] }

  before do
    rental_calculator = RentalCalculator.new(total_days, price_per_day, price_per_km, distance)
    @price = rental_calculator.calculate_total_amount
    @decreased_value = rental_calculator.get_decreased_value(@price, 30)
  end
  describe "when file is not empty" do
    it "should be valid " do
      file = File.open('data/input.json')
      _(merge_rentals_data(file).length).must_be :>, 0
    end

    describe "when keys are not valid" do
      it "return raise NoMethodError" do
        file = File.open('data/input_fixture.json')
        input = DataMerger::convert_file_to_json(file)
        proc { DataValidator::validate(input) }.must_raise(InvalidateRentalsDataError)
      end
    end

    it 'return valid stackholders amounts' do
      commission = Commission.new(@decreased_value, total_days)
      driver = commission.get_actions(@price)[0][:amount]
      owner = commission.get_actions(@price)[1][:amount]
      insurance = commission.get_actions(@price)[2][:amount]
      assistance = commission.get_actions(@price)[3][:amount]
      drivy = commission.get_actions(@price)[4][:amount]
      _(owner).must_be :==, 2100
      _(driver).must_be :==, 3000
      _(insurance).must_be :==, 450
      _(assistance).must_be :==, 100
      _(drivy).must_be :==, 350
    end

    it 'return valid stackholders amounts with options available' do
      option_manager = OptionsManager.new(option, total_days)
      commission = Commission.new(@decreased_value, total_days, option_manager)
      driver = commission.get_actions(@price)[0][:amount]
      owner = commission.get_actions(@price)[1][:amount]
      insurance = commission.get_actions(@price)[2][:amount]
      assistance = commission.get_actions(@price)[3][:amount]
      drivy = commission.get_actions(@price)[4][:amount]
      _(owner).must_be :==, 2800
      _(driver).must_be :==, 3700
      _(insurance).must_be :==, 450
      _(assistance).must_be :==, 100
      _(drivy).must_be :==, 350
    end
  end
end
