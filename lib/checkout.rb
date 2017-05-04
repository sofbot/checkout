class Checkout
  attr_reader :basket, :promos, :gross_total

  def initialize(*args)
    @promos = args.flatten
    @basket = []
  end

  def scan(item)
    @basket << item
    "#{item.name} added to basket"
  end

  def total
    @promos.empty? ? format_total(parse_total) : apply_promos
  end

  def parse_total
    return 0 if @basket.empty?
    @basket.map { |item| item.price }.reduce(:+)
  end

  def format_total(amt)
    gbp = "\u00A3".encode('utf-8')
    return "#{gbp}0" if amt.zero?
    "Total price: #{gbp}#{amt.to_s('F')}"
  end

  def apply_promos
    apply_product_based_promos unless product_based_promos.empty?

    overall_promos.empty? ? format_total(parse_total) : apply_overall_promos
  end

  def apply_product_based_promos
    product_based_promos.each do |promo|
      if meets_min_quantity?(promo) || meets_min_value?(promo)
        if promo.percent
          discounted(promo)[0].price *= (1 - promo.discount)
        else
          discounted(promo)[0].price -= promo.discount
        end
      end
    end
  end

  def meets_min_quantity?(promo)
    return false if promo.min_quantity.nil?
    discounted(promo).length >= promo.min_quantity
  end

  def meets_min_value?(promo)
    return false if promo.min_value.nil?
    parse_total >= promo.min_value
  end

  def discounted(promo)
    @basket.select { |item| item.code == promo.product_code }
  end

  def product_based_promos
    @promos.select { |promo| !promo.product_code.nil? }
  end

  def overall_promos
    @promos.select { |promo| promo.product_code.nil? }
  end

  def apply_overall_promos
    net_total = parse_total

    overall_promos.each do |promo|
      if meets_min_quantity?(promo) || meets_min_value?(promo)
        if promo.percent
          net_total *= (1 - promo.discount)
        else
          net_total -= promo.discount
        end
      end
    end

    format_total(net_total.round(2))
  end
end
