require 'rails_helper'

RSpec.describe Product, type: :model do

  describe '#update_amazon_api_data' do
    it 'updates amazon api data' do
      amazon_api_data = {'title' => 'amazon product', 'price' => 777}
      allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
      product = create(:product, price_in_cents: 1000, offer_url: "https://www.amazon.com/dp/B015PYYDMQ", amazon_api_data_updated_at: DateTime.parse('24.01.2017'))

      product.update_amazon_api_data

      expect(product.amazon_api_data).to eq amazon_api_data
      expect(product.amazon_api_data_updated_at).to_not eq DateTime.parse('24.01.2017')
    end

    context 'when empty response' do
      it 'does not update amazon api data' do
        amazon_api_data = {}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product,
                         price_in_cents: 1000,
                         offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                         amazon_api_data_updated_at: DateTime.parse('24.01.2017'),
                         amazon_api_data: {'price' => 777, 'title' => 'test product'})

        product.update_amazon_api_data

        expect(product.amazon_api_data).to eq ({'price' => 777, 'title' => 'test product'})
      end
      it 'updates amazon api data timestamp' do
        amazon_api_data = {}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product,
                         price_in_cents: 1000,
                         offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                         amazon_api_data_updated_at: DateTime.parse('24.01.2017'),
                         amazon_api_data: {'price' => 777, 'title' => 'test product'})

        product.update_amazon_api_data

        expect(product.amazon_api_data_updated_at).to_not eq DateTime.parse('24.01.2017')
      end
    end
  end

  describe '#update_price' do
    it 'updates product price' do
      amazon_api_data = {'price' => 999, 'title' => 'test product'}
      allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
      product = create(:product,
                       price_in_cents: 1000,
                       offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                       price_updated_at: DateTime.parse('24.01.2017'),
                       amazon_api_data_updated_at: DateTime.parse('24.01.2017'))

      product.update_price

      expect(product.price_in_cents).to eq 999
      expect(product.price_updated_at).to_not eq DateTime.parse('24.01.2017')
      expect(product.amazon_api_data_updated_at).to_not eq DateTime.parse('24.01.2017')
    end

    context 'when price N/A' do
      it 'does not update price' do
        amazon_api_data = {'price' => '', 'title' => 'test product'}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product, price_in_cents: 1000, offer_url: "https://www.amazon.com/dp/B015PYYDMQ", price_updated_at: DateTime.parse('24.01.2017'))

        product.update_price

        expect(product.price_in_cents).to eq 1000
      end

      it 'does not update price timestamp' do
        amazon_api_data = {'price' => '', 'title' => 'test product'}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product, price_in_cents: 1000, offer_url: "https://www.amazon.com/dp/B015PYYDMQ", price_updated_at: DateTime.parse('24.01.2017'))

        product.update_price

        expect(product.price_updated_at).to eq DateTime.parse('24.01.2017')
      end

      it 'updates amazon api data' do
        amazon_api_data = {'price' => '', 'title' => 'test product'}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product, price_in_cents: 1000, offer_url: "https://www.amazon.com/dp/B015PYYDMQ", price_updated_at: DateTime.parse('24.01.2017'))

        product.update_price

        expect(product.amazon_api_data).to eq amazon_api_data
      end
      
      it 'updates amazon api data timestamp' do
        amazon_api_data = {'price' => '', 'title' => 'test product'}
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([amazon_api_data])
        product = create(:product, price_in_cents: 1000, offer_url: "https://www.amazon.com/dp/B015PYYDMQ", price_updated_at: DateTime.parse('24.01.2017'))

        product.update_price

        expect(product.amazon_api_data_updated_at).to_not eq DateTime.parse('24.01.2017')
      end
    end
  end

  describe '#update_amazon_www_data' do
    it 'updates amazon www data' do
      amazon_www_data = {'RAM' => '8 GB'} 
      allow_any_instance_of(AmazonScraper).to receive(:technical_details).and_return(amazon_www_data)
      product = create(:product,
                       offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                       amazon_www_data_updated_at: DateTime.parse('24.01.2017'),
                       amazon_www_data: {'RAM' => '16 GB'})

      product.update_amazon_www_data

      expect(product.amazon_www_data).to eq amazon_www_data
      expect(product.amazon_www_data_updated_at).to_not eq DateTime.parse('24.01.2017')
    end

    it 'does not update amazon www data when empty response' do
      amazon_www_data = {} 
      allow_any_instance_of(AmazonScraper).to receive(:technical_details).and_return(amazon_www_data)
      product = create(:product,
                       offer_url: "https://www.amazon.com/dp/B015PYYDMQ",
                       amazon_www_data_updated_at: DateTime.parse('24.01.2017'),
                       amazon_www_data: {'RAM' => '16 GB'})

      product.update_amazon_www_data

      expect(product.amazon_www_data).to eq ({'RAM' => '16 GB'})
      expect(product.amazon_www_data_updated_at).to_not eq DateTime.parse('24.01.2017')
    end
  end
end

