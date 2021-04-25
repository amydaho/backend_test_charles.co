
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
    @commission  = Commission.new(decreased_value, total_days)
  end
  describe "when file is not empty" do
    it "should be valid " do
      file = File.open('data/input.json')
      _(merge_rentals_data(file).length).must_be :>, 0
    end

    describe "when keys are not valid" do
      it "return raise NoMethodError" do
        file = File.open('data/input_fixture.json')
        proc { merge_rentals_data(file) }.must_raise(NoMethodError)
      end
    end
  end
end
