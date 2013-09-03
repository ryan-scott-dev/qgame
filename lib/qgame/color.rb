class Color < Vec4
  alias_method :r,  :x
  alias_method :r=, :x=

  alias_method :g,  :y
  alias_method :g=, :y=

  alias_method :b,  :z
  alias_method :b=, :z=

  alias_method :a,  :w
  alias_method :a=, :w=

  def self.black
    Color.new
  end

  def self.red
    Color.new(1, 0, 0, 0)
  end

  def self.green
    Color.new(0, 1, 0, 0)
  end

  def self.blue
    Color.new(0, 0, 1, 0)
  end

end
