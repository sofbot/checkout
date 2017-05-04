require 'byebug'
require 'checkout'
require 'promo'
require 'product'


describe Checkout do
  let(:heart) { Product.new('001', 'Lavender heart', '9.25') }
  let(:cufflinks) { Product.new('002', 'Personalised cufflinks', '45')}
  let(:shirt) { Product.new('003', 'Kids T-shirt', '19.95') }
  let(:product_promo) { Promo.new({discount: 0.75, min_quantity: 2, product_code: '001', percent: false }) }
  let(:overall_promo) { Promo.new({ discount: 0.1, min_value: 65, percent: true }) }
  let(:empty_checkout) { Checkout.new() }
  subject(:co) { Checkout.new([product_promo, overall_promo]) }

  describe '#initialize' do
    it 'creates a new checkout with an array of promotional rules' do
      expect(co.promos).to be_an(Array)
      expect(co.promos).to all(be_a(Promo))
    end
  end

  describe '#scan' do
    it 'adds an item to basket' do
      co.scan(heart)
      expect(co.basket).to include(heart)
    end
  end

  describe '#total' do
    context 'when no promos were passed to the checkout' do
      it 'returns the sum of all scanned item values' do
        empty_checkout.scan(cufflinks)
        empty_checkout.scan(shirt)
        expect(empty_checkout.total).to eq("Total price: £64.95")
      end
    end

    context 'when promos were passed' do
      it 'returns total after discounts' do
        co.scan(heart)
        co.scan(cufflinks)
        co.scan(shirt)
        expect(co.total).to eq("Total price: £66.78")
      end
    end

    it 'returns 0 if no items were scanned' do
      expect(empty_checkout.total).to eq("£0")
    end
  end

  describe '#parse_total' do
    it 'returns the current sum of all scanned product values' do
      empty_checkout.scan(heart)
      empty_checkout.scan(shirt)
      expect(empty_checkout.parse_total).to be_within(1e-12).of(29.20)
    end
  end

  describe '#format_total' do
    it 'converts bigDecimal to string and prepends the gbp sign' do
      co.scan(heart)
      expect(co.total).to eq("Total price: £9.25")
    end
  end

  describe '#apply_promos' do
    context 'when we have product based promos available' do
      it 'applies product based promos' do
        allow(co).to receive(:apply_product_based_promos)
        co.apply_promos
        expect(co).to have_received(:apply_product_based_promos)
      end
    end

    context 'when we have overall promos available' do
      it 'applies overall promos' do
        allow(co).to receive(:apply_overall_promos)
        co.apply_promos
        expect(co).to have_received(:apply_overall_promos)
      end
    end

    context 'when we have no promos available' do
      it 'returns the checkout total' do
        empty_checkout.scan(heart)
        empty_checkout.scan(heart)
        expect(empty_checkout.total).to eq("Total price: £18.5")
      end
    end
  end

  describe '#apply_product_based_promos' do
    it 'checks if each promo meets min quantity' do
      allow(co).to receive(:meets_min_quantity?)
      co.apply_product_based_promos
      expect(co).to have_received(:meets_min_quantity?).with(kind_of(Promo))
    end

    it 'checks if each promo meets min value' do
      allow(co).to receive(:meets_min_value?)
      co.apply_product_based_promos
      expect(co).to have_received(:meets_min_value?)
    end

    it 'applies discounts that meet min requirements' do
      co.scan(heart)
      co.scan(shirt)
      co.scan(heart)
      expect(co.total).to eq("Total price: £36.95")
    end
  end

  describe '#meets_min_quantity?(promo)' do
    it 'returns false if promo has no min quantity' do
      expect(co.meets_min_quantity?(overall_promo)).to be(false)
    end

    it 'returns false if checkout doesn\'t meet min quantity' do
      co.scan(heart)
      expect(co.meets_min_quantity?(product_promo)).to be(false)
    end

    it 'returns true if promo has a min quantity and checkout satisfies min' do
      co.scan(heart)
      co.scan(heart)
      expect(co.meets_min_quantity?(product_promo)).to be(true)
    end
  end

  describe '#meets_min_value?(promo)' do
    it 'returns false if promo has no min value' do
      expect(co.meets_min_value?(product_promo)).to be(false)
    end

    it 'returns false if checkout doesn\'t meet min value' do
      expect(empty_checkout.meets_min_value?(product_promo)).to be(false)
    end

    it 'returns true if promo has a min value and checkout satisfies min' do
      co.scan(heart)
      co.scan(cufflinks)
      co.scan(heart)
      co.scan(shirt)
      expect(co.meets_min_value?(overall_promo)).to be(true)
    end
  end

  describe '#discounted' do
    it 'returns a hash of items that are eligible for the passed promo' do
      co.scan(heart)
      co.scan(cufflinks)
      expect(co.discounted(product_promo)).to include(heart)
    end
  end

  describe '#product_based_promos' do
    it 'returns an array of promos to be applied to certain products' do
      expect(co.product_based_promos).to include(product_promo)
      expect(co.product_based_promos).not_to include(overall_promo)
    end
  end

  describe '#overall_promos' do
    it 'returns an array of promos to be applied to the checkout total' do
      expect(co.overall_promos).to include(overall_promo)
      expect(co.overall_promos).not_to include(product_promo)
    end
  end

  describe '#apply_overall_promos' do
    it 'returns net total after discounts' do
      co.scan(heart)
      co.scan(cufflinks)
      co.scan(heart)
      co.scan(shirt)
      expect(co.total).to eq("Total price: £73.76")
    end
  end
end
