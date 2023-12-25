require 'rails_helper'

RSpec.describe 'PixelChanges', type: :request do
  describe 'POST /paintings/:painting_id/pixel_changes' do
    let!(:painting) { create :painting, width: 20, height: 20 }
    let(:row) { 15 }
    let(:col) { 15 }
    let(:color) { 'a0b0c0' }
    let(:put_pixel) do
      post(
        "/paintings/#{painting.id}/pixel_changes",
        params: { row: row, col: col, color: color },
        headers: { "Content-Type" => "application/json" },
        as: :json
      )
    end

    context 'when not authorized' do
      it 'returns 401' do
        put_pixel 

        expect(response).to have_http_status(401)
      end
    end

    context 'when authorized' do
      let(:user) { create :user }

      before { sign_in user }

      it 'creates a pixel' do
        expect { put_pixel }.to change(Pixel.where(painting: painting), :count).by(1)
      end

      it 'returns no content' do
        put_pixel

        expect(response).to have_http_status(204)
      end

      context 'when params invalid' do
        let(:color) { 'xyz' }

        it 'returns 422' do
          put_pixel

          expect(response).to have_http_status(422)
        end
      end
    end
  end
end
