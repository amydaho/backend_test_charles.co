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

  def initialize(decreased_value, day_count, options_manager = nil)
    @decreased = decreased_value
    @day_count = day_count
    @options_manager = options_manager
  end

  def get_insurance_fee
    @decreased / 2
  end

  def get_assistance_fee
    @day_count * 100
  end

  def get_drivy_fee
    @decreased - (get_insurance_fee + get_assistance_fee)
  end

  def build_action(who, type, amount)
    {
        "who": who,
        "type": type,
        "amount": calculate_amount_for_stakeholder(who, amount)
    }
  end

  def calculate_amount_for_stakeholder(who, amount)
    if @options_manager == nil
      amount
    else
      if who == Stakeholders::DRIVER
        amount + @options_manager.options_fees.sum
      elsif who == Stakeholders::OWNER
        @options_manager.check_owner_options ? amount + @options_manager.options_fees.sum : amount
      elsif who == Stakeholders::DRIVY
        @options_manager.check_drivy_options ? amount + @options_manager.options_fees.sum : amount
      elsif who == Stakeholders::INSURANCE or Stakeholders::ASSISTANCE
        amount
      end
    end
  end

  def get_actions(amount)
    STAKEHOLDERS.map do |stakeholder|
      if stakeholder == Stakeholders::DRIVER
        build_action(stakeholder, ActionType::DEBIT, amount)
      elsif stakeholder == Stakeholders::OWNER
        build_action(stakeholder, ActionType::CREDIT, amount - @decreased)
      elsif stakeholder == Stakeholders::INSURANCE
        build_action(stakeholder, ActionType::CREDIT, get_insurance_fee)
      elsif stakeholder == Stakeholders::ASSISTANCE
        build_action(stakeholder, ActionType::CREDIT, get_assistance_fee)
      elsif stakeholder == Stakeholders::DRIVY
        build_action(stakeholder, ActionType::CREDIT, get_drivy_fee)
      end
    end
  end
end