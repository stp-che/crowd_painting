require 'rails_helper'

RSpec.describe Paintings::BuildCanvas do
  let(:painting) { build :painting, width: 50, height: 30 }
  let(:image_blob) { described_class.new.call(painting) }
  let(:image) { ChunkyPNG::Image.from_datastream(ChunkyPNG::Datastream.from_blob(image_blob)) }
  let(:white_color) { ChunkyPNG::Color.parse('#ffffff') }

  context 'when painting has no pixels' do
    it 'builds image with white canvas' do
      expect(image.width).to eq 50
      expect(image.height).to eq 30
      expect(image.pixels).to eq Array.new(1500) { white_color }
    end
  end

  context 'when painting has pixels' do
    before do
      painting.pixels.build(row: 2, col: 5, color: "\xAF\x8C\x11")
      painting.pixels.build(row: 20, col: 42, color: "\xD2\x08\xB5")
    end

    it 'builds image with pixes colors' do
      expected_pixels = Array.new(1500) { white_color }
      expected_pixels[105] = ChunkyPNG::Color.parse('#af8c11')
      expected_pixels[1042] = ChunkyPNG::Color.parse('#d208b5')
      expect(image.pixels).to eq expected_pixels
    end
  end
end
