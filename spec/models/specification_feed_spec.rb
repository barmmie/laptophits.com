require 'rails_helper'

RSpec.describe SpecificationFeed, type: :model do
  describe 'Associations' do
    it {expect(subject).to belong_to(:product)}
  end
end
