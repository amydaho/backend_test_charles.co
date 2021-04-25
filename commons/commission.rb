module ActionType
  CREDIT = 'credit'
  DEBIT = 'debit'
end

##
# Module of commission stakeholders
##
module Stakeholders
  DRIVER = 'driver'
  OWNER = 'owner'
  INSURANCE = 'insurance'
  ASSISTANCE = 'assistance'
  DRIVY = 'drivy'
end

##
# This class is responsible for calculating all stakeholders commissions
##
class Commission

  STAKEHOLDERS = [Stakeholders::DRIVER, Stakeholders::OWNER, Stakeholders::INSURANCE, Stakeholders::ASSISTANCE, Stakeholders::DRIVY]

  def initialize(value, day_count)
    @value = value
    @day_count = day_count
  end

  def get_insurance_fee
    @value / 2
  end

  def get_assistance_fee
    @day_count * 100
  end

  def get_drivy_fee
    @value - (get_insurance_fee + get_assistance_fee)
  end

  def build_action(who, type, amount)
    {
        "who": who,
        "type": type,
        "amount": amount
    }
  end

  def get_actions(amount)
    STAKEHOLDERS.map do |stakeholder|
      if stakeholder == Stakeholders::DRIVER
        build_action(stakeholder, ActionType::DEBIT, amount)
      elsif stakeholder == Stakeholders::OWNER
        build_action(stakeholder, ActionType::CREDIT, amount - @value)
      elsif stakeholder == Stakeholders::INSURANCE
        build_action(stakeholder, ActionType::CREDIT, get_insurance_fee)
      elsif stakeholder == Stakeholders::ASSISTANCE
        build_action(stakeholder, ActionType::CREDIT, get_assistance_fee)
      elsif  stakeholder == Stakeholders::DRIVY
        build_action(stakeholder, ActionType::CREDIT, get_drivy_fee)
      end
    end
  end
end