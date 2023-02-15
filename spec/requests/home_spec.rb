require 'rails_helper'

describe 'Home', type: :request do
  let!(:user) { User.create(email: 'email@example.com') }
  before do
    sign_in user
  end

  it 'renders index' do
    get '/'
    expect(response).to render_template(:index)
    expect(response.status).to eq(200)
  end

  it 'creates short link' do
    post '/generate', params: { short_link_form: { link: 'https://example.com', short_link: 'meoow', expired_at: nil } }
    expect(response.body).to include("Here is your link: <a href=\"/meoow\">http://www.example.com/meoow</a>")
  end
end
