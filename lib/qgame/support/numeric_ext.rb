class Numeric
  def milliseconds
    self / 1000.0
  end
  alias :millisecond :milliseconds

  def seconds
    self
  end
  alias :second :seconds

  def minutes
    self * 60
  end
  alias :minute :minutes

  def hours
    self * 3600
  end
  alias :hour :hours

  def days
    self * 24.hours
  end
  alias :day :days

  def weeks
    self * 7.days
  end
  alias :week :weeks

  def fortnights
    self * 2.weeks
  end
  alias :fortnight :fortnights

  def clamp(range)
    return range.begin if self < range.begin
    return range.end if self > range.end
    self
  end
end
