##
# Class: This class is responsible for all rental calculation
##
class RentalCalculator

  PERCENT10 = 10
  PERCENT30 = 30
  PERCENT50 = 50

  def initialize(total_days, price_per_day, price_per_km, distance)
    @total_days = total_days
    @price_per_day = price_per_day
    @price_per_km = price_per_km
    @distance = distance
  end

  def calculate_total_amount
    case @total_days
    when 1
      @price_per_day + calculate_price_per_km(@price_per_km, @distance)
    when 2..4
      get_decreased_value_10_percent(@price_per_day, @total_days) + calculate_price_per_km(@price_per_km, @distance)
    when 5..10
     get_decreased_value_30_percent(@price_per_day, @total_days) + calculate_price_per_km(@price_per_km, @total_days)
    else
      get_decreased_value_50_percent(@price_per_day, @total_days) + calculate_price_per_km(@price_per_km, @distance)
    end
  end

  ##
  # Method: Montant de la reduction
  # @param : price_per_day: int
  ##
  def get_decreased_value(price, percent)
    price * percent / 100
  end
  private
  ##
  # Method: Calcule des montant par jour
  # @param : price_per_day: int, day_count: int
  ##
  def calculate_price_per_day(price_per_day, day_count)
    price_per_day * day_count
  end

  ##
  # Method: Calcule des montant par Km
  #  @param : price_per_km: int, day_count: int
  ##
  def calculate_price_per_km(price_per_km, day_count)
    price_per_km * day_count
  end

  ##
  # Method: Calcule des montant par jour par pourcentage
  # @param : number_of_days: int, price_per_day: int, percent: float
  ##
  def value_per_day_per_percent(number_of_days, price_per_day, percent)
    calculate_price_per_day(price_per_day, number_of_days) - number_of_days * get_decreased_value(price_per_day, percent)
  end

  ##
  # Method: Montant maximale pour une reduction de 10%
  # @param : price_per_day: int
  ##
  def max_for_10_percent(price_per_day)
    3 * (price_per_day - get_decreased_value(price_per_day, PERCENT10))
  end

  ##
  # Method: Montant maximale pour une reduction de 30%
  # @param : price_per_day: int
  ##
  def max_for_30_percent(price_per_day)
    6 * (price_per_day - get_decreased_value(price_per_day, PERCENT30))
  end

  ##
  # Method: Montant de la reduction de 10%
  # @param : price_per_day: int
  ##
  def get_decreased_value_10_percent(price_per_day, total_days)
    price_per_day + value_per_day_per_percent(total_days - 1, price_per_day,PERCENT10)
  end

  ##
  # Method: Montant de la reduction de 30%
  # @param : price_per_day: int
  ##
  def get_decreased_value_30_percent(price_per_day, total_days)
    price_per_day + max_for_10_percent(price_per_day) + value_per_day_per_percent(total_days - 4, price_per_day,PERCENT30)
  end

  ##
  # Method: Montant de la reduction de 50%
  # @param : price_per_day: int
  ##
  def get_decreased_value_50_percent(price_per_day, total_days)
    price_per_day + max_for_10_percent(price_per_day) + max_for_30_percent(price_per_day) + value_per_day_per_percent(total_days - 10, price_per_day,PERCENT50)
  end

end