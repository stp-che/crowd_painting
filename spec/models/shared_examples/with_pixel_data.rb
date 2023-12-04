RSpec.shared_examples 'with pixel data' do |factory|
  describe 'pixel data validation' do
    subject(:record) { build factory }

    it { is_expected.to be_valid }

    context 'when row is negative' do
      before { record.row = -1 }

      it { is_expected.to_not be_valid }
    end

    context 'when col is negative' do
      before { record.col = -1 }

      it { is_expected.to_not be_valid }
    end
  end

  describe '#color' do
    it 'is stored as binary and is serialized as PixelData::Color' do
      color_bin = "\xAF\x8C\x11".force_encoding(Encoding::BINARY)
      color = PixelData::Color.new(color_bin)
      record = create factory, color: color
      record.reload

      expect(record.color).to be_kind_of PixelData::Color
      expect(record.color.binary_str).to eq color_bin
    end
  end

  describe '#color=' do
    let(:record) { build factory }

    context 'when value is a correct binary string' do
      it 'is converted to PixelData::Color' do
        record.color = "\xAF\x8C\x11"

        expect(record.color).to be_kind_of PixelData::Color
        expect(record.color.binary_str).to eq "\xAF\x8C\x11".force_encoding(Encoding::BINARY)
      end
    end

    context 'when color len is > 3' do
      it 'raises error' do
        expect { record.color = "\xAF\x8C" }.to raise_error PixelData::Color::InvalidBinary
      end
    end
  end
end
