require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Associations' do
    it { expect(subject).to have_many(:specification_feeds) }
  end

  describe '#update_spec' do
    it 'updates product specs' do 
      product = create(:product, brand: nil)
      product.specification_feeds << create(:specification_feed, source: 'amazon_api', data: {"title" => 'Asus laptop'}) 

      expect{ product.update_spec }.to change{product.brand}.from(nil).to('Asus')
    end
  end

  describe '#update_price' do
    it 'updates product price' do
      amazon_api_data = {'price' => 999, 'title' => 'test product'}
      allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
      product = create(:product,
                       price_in_cents: 1000,
                       offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                       price_updated_at: DateTime.parse('24.01.2017'))
      product.specification_feeds << create( :specification_feed, source: 'amazon_api', data: {}, updated_at: DateTime.parse('24.01.2017'))

      product.update_price

      expect(product.price_in_cents).to eq 999
      expect(product.price_updated_at).to_not eq DateTime.parse('24.01.2017')
      expect(product.specification_feeds.first.updated_at).to_not eq DateTime.parse('24.01.2017') 
    end

    context 'when price N/A' do
      it 'does not update price' do
        amazon_api_data = {'price' => '', 'title' => 'test product'}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product,
                         price_in_cents: 1000,
                         offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                         price_updated_at: DateTime.parse('24.01.2017'))

        product.specification_feeds << create( :specification_feed, source: 'amazon_api', data: {}, updated_at: DateTime.parse('24.01.2017'))

        product.update_price

        expect(product.price_in_cents).to eq 1000
      end

      it 'does not update price timestamp' do
        amazon_api_data = {'price' => '', 'title' => 'test product'}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])

        product = create(:product,
                         price_in_cents: 1000,
                         offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                         price_updated_at: DateTime.parse('24.01.2017'))

        product.specification_feeds << create( :specification_feed, source: 'amazon_api', data: {'price' => 1000}, updated_at: DateTime.parse('24.01.2017'))

        product.update_price

        expect(product.price_updated_at).to eq DateTime.parse('24.01.2017')
      end
    end
  end
end

