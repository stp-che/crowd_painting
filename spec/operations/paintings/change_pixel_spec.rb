require 'rails_helper'

RSpec.describe Paintings::ChangePixel do
  let(:user) { create :user }
  let(:painting) { create :painting, width: 50, height: 30 }
  let(:result) { described_class.new.call(user, painting.id, params) }
  let(:params) { { row: row, col: col, color: color } }
  let(:row) { 29 }
  let(:col) { 49 }
  let(:color) { '6f05de' }

  it 'returns success' do
    expect(result).to be_success
  end

  it 'creates PixelChange' do
    expect { result }.to change(PixelChange, :count).by 1
    expect(PixelChange.last).to have_attributes(
      user: user,
      painting: painting,
      row: row,
      col: col,
      color: PixelData::Color.parse_json(color)
    )
  end

  context 'when pixel does not exist' do
    it 'creates pixel for painting' do
      expect { result }.to change(Pixel, :count).by 1
      px = Pixel.find_by(painting: painting, row: row, col: col)
      expect(px.color.as_json).to eq color
    end
  end

  context 'when pixel exists' do
    let!(:px) { painting.pixels.create! row: row, col: col, color: "\x00\x00\x00" }

    it 'updates pixel color' do
      expect { result }.to_not change(Pixel, :count)
      expect(px.reload.color.as_json).to eq color
    end
  end

  shared_examples 'with error' do |error_key|
    it 'returns failure' do
      expect(result).to be_failure
    end

    it 'adds error on row' do
      expect(result.failure[error_key]).to be_present
    end
  end

  context 'when row out of bounds' do
    let(:row) { 30 }

    include_examples 'with error', :row
  end

  context 'when col out of bounds' do
    let(:col) { 50 }

    include_examples 'with error', :col
  end

  context 'when color invalid' do
    let(:color) { 'abcdex' }

    include_examples 'with error', :color
  end
end
