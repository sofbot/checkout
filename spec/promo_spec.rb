require 'promo'

describe Promo do
  let(:options) {{
    discount: 0.75,
    min_quantity: 2,
    product_code: '001',
    percent: false
  }}

  subject(:promo) { Promo.new(options) }

  describe '#initialize' do
    it 'creates a new promo instance' do
      expect(promo.product_code).to eq('001')
      expect(promo.discount).to eq(0.75)
      expect(promo.min_quantity).to eq(2)
      expect(promo.min_value).to be(nil)
      expect(promo.percent).to be(false)
    end
  end
end
