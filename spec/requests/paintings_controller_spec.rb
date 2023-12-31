require 'rails_helper'

RSpec.describe 'Paintings', type: :request do
  describe 'POST /paintings' do
    let(:size) { Painting::SIZES.keys.first }
    let(:title) { 'My Painting' }
    let(:post_painting) { post '/paintings', params: { painting: { size: size, title: title } } }

    context 'when not authorized' do
      it 'redirects to sign in' do
        post_painting

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(user_session_path)
      end
    end

    context 'when authorized' do
      let(:user) { create :user }

      before { sign_in user }

      it 'creates a painting' do
        expect { post_painting }.to change(Painting.where(user: user), :count).by(1)
      end

      it 'redirects to paintings list' do
        post_painting

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(paintings_path)
      end
    end
  end
end
