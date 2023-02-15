require 'rails_helper'

describe ShortLinkGenerationService do
  let(:url) { 'https://masha.com/home' }

  subject { described_class.call(url, DateTime.tomorrow, nil) }

  it 'saves url in redis' do
    shortened_url = subject
    uid = shortened_url.split('/').last

    expect(Redis.current.get(uid)).to eq(url)
    expect(Redis.current.ttl(uid)).to be >= 0
  end

  context 'expiration date is not passed' do
    subject { described_class.call(url, nil, nil) }

    before do
      Redis.current.flushall
    end

    it 'saves url in redis' do
      shortened_url = subject
      uid = shortened_url.split('/').last

      expect(Redis.current.get(uid)).to eq(url)
      expect(Redis.current.ttl(uid)).to be >= 2592000
    end
  end
end
