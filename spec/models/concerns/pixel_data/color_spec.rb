require 'rails_helper'

RSpec.describe PixelData::Color do
  describe '.load' do
    it 'returns a color' do
      color = described_class.load "\x01\x02\x03"
      expect(color).to be_a described_class
      expect(color.binary_str).to eq "\x01\x02\x03"
    end

    context 'when data is nil' do
      it 'returns nil' do
        color = described_class.load nil
        expect(color).to be_nil
      end
    end

    context 'when data is invalid' do
      it 'raises PixelData::Color::InvalidBinary' do
        expect { described_class.load "\x01\x02" }.to raise_error PixelData::Color::InvalidBinary
        expect { described_class.load "\x01\x02\x03\x04" }.to raise_error PixelData::Color::InvalidBinary
      end
    end
  end

  describe '.dump' do
    it 'returns binary string' do
      color = described_class.new "\x01\x02\x03"
      data = described_class.dump(color)
      expect(data).to eq "\x01\x02\x03"
    end
  end

  describe '.parse_json' do
    it 'returns a color' do
      color = described_class.parse_json '010203'
      expect(color).to be_a described_class
      expect(color.binary_str).to eq "\x01\x02\x03".force_encoding(Encoding::BINARY)

      color = described_class.parse_json '000000'
      expect(color.binary_str).to eq "\x00\x00\x00".force_encoding(Encoding::BINARY)
    end

    it 'is case insensitive' do
      color = described_class.parse_json 'abCDeF'
      expect(color.binary_str).to eq "\xAB\xCD\xEF".force_encoding(Encoding::BINARY)
    end

    context 'when string is nil' do
      it 'returns nil' do
        color = described_class.parse_json nil
        expect(color).to be_nil
      end
    end

    context 'when string is invalid' do
      it 'raises PixelData::Color::InvalidString' do
        expect { described_class.parse_json '' }.to raise_error PixelData::Color::InvalidString
        expect { described_class.parse_json 'ABCDEX' }.to raise_error PixelData::Color::InvalidString
        expect { described_class.parse_json '000' }.to raise_error PixelData::Color::InvalidString
      end
    end
  end

  describe '#as_json' do
    it 'returns string form of color' do
      color = described_class.new "\x01\x02\x03"
      expect(color.as_json).to eq '010203'

      color = described_class.new "\x00\x00\x00"
      expect(color.as_json).to eq '000000'
    end
  end

  describe '#hex_str' do
    it 'returns string form of color' do
      color = described_class.new "\x01\x02\x03"
      expect(color.hex_str).to eq '#010203'

      color = described_class.new "\x00\x00\x00"
      expect(color.hex_str).to eq '#000000'
    end
  end
end
