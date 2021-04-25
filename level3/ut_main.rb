
require 'minitest/autorun'
require_relative 'main.rb'
require 'minitest/spec'


describe main do

  let(:price_per_day) {2000}
  let(:price_per_km) {200}
  let(:total_days) {10}
  let(:distance) {10}
  let(:percent) {10}
  let(:amount) {5000}
  let(:decreased_value) {5000}
  let(:insurance_fee) {2500}
  let(:assistance_fee) {1000}

  before do
    @rental_calculator1 = RentalCalculator.new(total_days, price_per_day, price_per_km, distance )
    @rental_calculator2 = RentalCalculator.new(total_days, price_per_day, price_per_km, distance )
    @commission         = Commission.new

  end
  describe "when file is not empty" do
    it "should be valid " do
      file = File.open('data/input.json')
      _(merge_rentals_data(file).length).must_be :>, 0
    end

    it 'return rental amount' do
      _(@rental_calculator1.calculate_total_amount).must_be :==, 17800
    end

    it 'return decreased value' do
      _(@rental_calculator2.get_decreased_value(amount, percent)).must_be :==, 500
    end

    it 'return insurance fee' do
      _(@commission.get_insurance_fee(decreased_value)).must_be :==, 2500
    end

    it 'return assistance fee' do
      _(@commission.get_assistance_fee(total_days)).must_be :==, 1000
    end

    it 'return drivy fee' do
      _(@commission.get_drivy_fee(decreased_value, insurance_fee, assistance_fee)).must_be :==, 1500
    end
  end
end
