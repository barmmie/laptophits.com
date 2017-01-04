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
      let(:values) { (-5..5).to_a }

      it 'calculates range distribution' do
      end

      context 'with nil values' do
      end

      context 'with positive infinity' do
      end

      context 'with negative infinity' do
      end
    end
  end
end
