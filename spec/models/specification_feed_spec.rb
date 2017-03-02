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
end
