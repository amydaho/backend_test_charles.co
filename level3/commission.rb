##
# This class is responsible for calculating all stakeholders commissions
##
class Commission

  def get_insurance_fee(decreased_value)
    decreased_value / 2
  end

  def get_assistance_fee(day_count)
    day_count * 100
  end

  def get_drivy_fee(decreased_value, insurance_fee, assistance_fee)
    decreased_value - (insurance_fee + assistance_fee)
  end
end