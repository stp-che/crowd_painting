require 'rails_helper'

RSpec.describe 'PixelChanges', type: :request do
  describe 'GET /paintings/:painting_id/pixels' do
    let!(:painting) { create :painting, width: 20, height: 20 }
    let(:now) { Time.current }
    let(:pixels_data) do
      [
        { row: 1, col: 1, color: '000000', updated_at: '2023-12-26T12:42:08.162Z' },
        { row: 2, col: 2, color: '000000', updated_at: '2023-12-26T13:00:00.000Z' },
        { row: 3, col: 3, color: '000000', updated_at: '2023-12-26T13:00:00.678Z' }
      ]
    end
    let(:get_pixels) do
      get(
        "/paintings/#{painting.id}/pixels",
        params: params,
        headers: { "Accept" => "application/json" }
      )
    end
    let(:params) { {} }
    let(:response_json) { JSON.parse(response.body).map(&:symbolize_keys) }

    before do
      pixels_data.each do |attrs|
        color = PixelData::Color.parse_json(attrs[:color])
        create(:pixel, painting: painting, color: color, **attrs.except(:color))
      end
    end

    context 'when not authorized' do
      it 'returns 401' do
        get_pixels 

        expect(response).to have_http_status(401)
      end
    end

    context 'when authorized' do
      let(:user) { create :user }

      before { sign_in user }

      it 'returns painting pixels' do
        get_pixels

        expect(response).to have_http_status(200)
        expect(response_json).to match_array(
          pixels_data.map { |attrs| include(attrs) }
        )
      end

      context 'with :after param' do
        let(:params) { { after: after } }
        let(:after) { '2023-12-26T13:00:00.000Z' }

        it 'returns only pixels with updated_at after the given value' do
          get_pixels

          expect(response_json).to contain_exactly include(pixels_data[2])
        end

        context 'when param is invalid' do
          let(:after) { 'abc' }

          it 'returns 400' do
            get_pixels

            expect(response).to have_http_status(400)
          end
        end
      end
    end
  end
end
