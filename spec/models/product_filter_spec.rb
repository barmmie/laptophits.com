require 'rails_helper'

RSpec.describe ProductFilter, type: :model do
  describe '#filter_by' do
    it 'filter products by brand' do
      create(:product, title: 'Asus laptop', brand: 'Asus').comments << create(:comment)
      create(:product, title: 'Dell laptop', brand: 'Dell').comments << create(:comment)
      create(:product, title: 'Other laptop', brand: nil).comments << create(:comment)


      expect(ProductFilter.new.filter_by('brand' => 'Asus').map(&:brand)).to eq ['Asus']
      expect(ProductFilter.new.filter_by('brand' => 'Dell').map(&:brand)).to eq ['Dell']
      expect(ProductFilter.new.filter_by('brand' => 'Other').map(&:brand)).to eq [nil]
    end
  end
end

