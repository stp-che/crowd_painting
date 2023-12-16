require 'rails_helper'

RSpec.describe Paintings::Create do
  let(:create_painting) { described_class.new.call user, params }
  let(:user) { create :user }
  let(:params) { { size: size, title: title } }
  let(:size) { Painting::SIZES.keys.first }
  let(:title) { 'The Painting' }

  it 'creates painting with proper params' do
    expect { create_painting }.to change(Painting, :count).by 1

    painting = Painting.last

    expect(painting).to have_attributes(
      user: user,
      width: Painting::SIZES[size].first,
      height: Painting::SIZES[size].last,
      title: title
    )
  end

  it 'returns Success with the new painting' do
    expect(create_painting).to be_success
    expect(create_painting.value!).to eq Painting.last
  end

  shared_examples 'error on' do |attr|
    it 'does not create painting' do
      expect { create_painting }.to_not change(Painting, :count)
    end

    it 'returns Failure with errors' do
      expect(create_painting).to be_failure
      expect(create_painting.failure[attr]).to be_present
    end
  end

  context 'when size is unknown' do
    let(:size) { '999999 x 999999' }

    include_examples 'error on', :size
  end

  context 'when size is nil' do
    let(:size) { nil }

    include_examples 'error on', :size
  end

  context 'when title is blank' do
    let(:title) { '' }

    it 'creates painting without title' do
      painting = create_painting.value!

      expect(painting.title).to be_nil
    end
  end

  context 'when title is nil' do
    let(:title) { nil }

    it 'creates painting without title' do
      painting = create_painting.value!

      expect(painting.title).to be_nil
    end
  end
end
