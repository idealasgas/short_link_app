require 'rails_helper'

describe 'Redirect', type: :request do
  let(:url) { 'https://google.com' }
  let(:token) { 'meoww' }

  context 'url exists' do
    before do
      Redis.current.set(token, url)
    end

    it 'redirects to url' do
      get "/#{token}"
      expect(response).to redirect_to(url)
    end
  end

  context 'url does not exist' do
    before do
      get "/#{token}"
    end

    it 'renders 404' do
      expect(response.status).to eq(404)
    end
  end
end
