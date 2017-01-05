require 'rails_helper'

RSpec.describe Distribution, type: :model do
  describe '#calculate' do
    context 'when value distribution' do
      let(:values) { [nil,1,1,1,2,2,3,'c','c'] }
      it 'calculates value distribution' do
        expect(Distribution.new(values).calculate).to eq ({1 => 3, 2 => 2, 3 => 1, nil => 1,'c' => 2})
      end
    end

    context 'when range distribution' do
      it 'calculates range distribution' do
        values = (0..10).to_a
        expect(Distribution.new(values,[9, 6, 2, 0]).calculate).to eq ({9 => 2, 6 => 3, 2 => 4, 0 => 2})
      end
    end
  end
end
