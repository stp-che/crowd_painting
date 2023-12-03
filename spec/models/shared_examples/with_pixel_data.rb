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

    context 'when color len is < 3' do
      before { record.color = "\xFF\xFF" }

      it { is_expected.to_not be_valid }
    end

    context 'when color len is > 3' do
      before { record.color = "\xFF\xFF\xFF\xFF" }

      it { is_expected.to_not be_valid }
    end
  end

  describe '#color' do
    it 'is stored as binary' do
      color = "\xAF\x8C\x11".force_encoding(Encoding::BINARY)
      record = create factory, color: color
      record.reload

      expect(record.color).to eq color
    end
  end
end
