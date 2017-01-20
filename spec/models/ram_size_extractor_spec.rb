require 'rails_helper'

RSpec.describe RamSizeExtractor, type: :model do
  describe '#extract' do
    it 'extracts ram size from text' do
      title = {
        '8GB DDR' => 8,
        '16GB Ram' => 16,
        '32 GB Memory' => 32,
        'ram: 24GB' => 24,
        'MEMORY: 16GB' => 16,
        '16GB 512GB' => 16,
        '8GB 1TB' => 8,
        '8GB, 256GB' => 8,
        '512 MB RAM' => 0.5
      }

      title.keys.each do |ram_text|
        expect(RamSizeExtractor.new(amazon_api_data: {'title' => ram_text}).extract).to eq title[ram_text]
      end
    end

    it 'extracts ram size from amazon www' do
      ram = {
        '8GB RAM' => 8,
        '16' => 16,
        '32 GB Memory' => 32,
        '512 MB RAM' => 0.5
      }

      ram.keys.each do |ram_text|
        expect(RamSizeExtractor.new(amazon_www_data: {'RAM' => ram_text}).extract).to eq ram[ram_text]
      end
    end
  end  
end
