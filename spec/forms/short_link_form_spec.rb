require 'rails_helper'

describe ShortLinkForm do
  describe 'validations' do
    it 'validates mandatory attributes' do
      form = described_class.new
      expect(form.valid?).to eq(false)
      expect(form.errors[:link]).to eq(["can't be blank"])
    end

    it 'validates expired_at is in future' do
      form = described_class.new(link: 'https://example.com/', expired_at: '02-02-2000')
      expect(form.valid?).to eq(false)
      expect(form.errors[:expired_at]).to eq(["can't be in the past"])
    end

    it 'validates link is valid' do
      form = described_class.new(link: 'meow')
      expect(form.valid?).to eq(false)
      expect(form.errors[:link]).to eq(["invalid"])
    end

    it 'validates short link is available in redis' do
      Redis.current.set('short', 'test')
      form = described_class.new(link: 'https://example.com/', short_link: 'short')
      expect(form.valid?).to eq(false)
      expect(form.errors[:short_link]).to eq(["not available"])
    end
  end
end
