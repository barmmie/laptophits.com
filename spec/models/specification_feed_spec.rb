require 'rails_helper'

RSpec.describe SpecificationFeed, type: :model do
  describe 'Validations' do
    it 'is invalid with duplicated source, product_id' do
      product = create(:product)
      product.specification_feeds << create(:specification_feed, source: 'manual')

      expect(build(:specification_feed, source: 'manual', product: product)).to_not be_valid
    end
  end

  describe 'Associations' do
    it {expect(subject).to belong_to(:product)}
  end

  describe '#refresh' do
    context 'when empty response' do
      let(:feed) { create(:specification_feed, source: 'amazon_api', uin: '0123456789', data: {'title' => 'Asus laptop'}) }

      before :each do
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([])
      end

      it 'refreshes updated_at' do
        expect{feed.refresh}.to change{feed.updated_at}
      end

      it 'does not updates data' do
        expect{feed.refresh}.to_not change{feed.data}
      end
    end

    context 'when returns the same data' do
      it 'refreshes updated_at' do
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([{'title' => 'Asus laptop'}])

        feed = create(:specification_feed, source: 'amazon_api', uin: '0123456789', data: {'title' => 'Asus laptop'})

        expect{feed.refresh}.to change{feed.updated_at}
      end

    end

    context 'when amazon_api source' do

      it 'refreshes feed data' do
        allow_any_instance_of(ProductExtractor).to receive(:get_products).and_return([{'title' => 'Dell laptop'}])

        feed = create(:specification_feed, source: 'amazon_api', uin: '0123456789', data: {'title' => 'Asus laptop'})

        expect{feed.refresh}.to change{feed.data['title']}.from('Asus laptop').to('Dell laptop')
      end
    end

    context 'when amazon_www source' do
      it 'refreshes feed data' do
        allow_any_instance_of(AmazonScraper).to receive(:technical_details).and_return({'Brand Name' => 'Dell'})

        feed = create(:specification_feed, source: 'amazon_www', uin: '0123456789', data: {'Brand Name' => 'Asus'})

        expect{feed.refresh}.to change{feed.data['Brand Name']}.from('Asus').to('Dell')
      end
    end
  end
end
