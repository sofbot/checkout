require 'bigdecimal'

class Product
  attr_reader :code, :name
  attr_accessor :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = BigDecimal.new(price)
  end
end
