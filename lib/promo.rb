class Promo
  attr_reader :product_code, :discount, :min_quantity,
              :min_value, :percent

  def initialize(options = {})
    @discount = options[:discount]
    @min_quantity = options[:min_quantity]
    @min_value = options[:min_value]
    @product_code = options[:product_code]
    @percent = options[:percent]
  end
end
