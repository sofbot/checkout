require 'product'

describe Product do
  subject(:product) { Product.new('001', 'Lavender heart', '9.25') }

  describe '#initialize' do
    it 'creates a new product' do
      expect(product.code).to eq('001')
      expect(product.name).to eq('Lavender heart')
      expect(product.price).to eq(9.25)
    end
  end
end
