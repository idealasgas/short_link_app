class ShortLinkGenerationService
  attr_reader :link, :ttl, :short_link

  def self.call(link, expired_at, short_link)
    new(link, expired_at, short_link).call
  end

  def initialize(link, expired_at, short_link)
    @link = link
    @ttl = expired_at.present? ? (expired_at.to_time - Time.current).to_i : 30.days.to_i
    @short_link = short_link
  end

  def call
    if short_link.present?
      Redis.current.set(short_link, link, ex: ttl, nx: true)
      short_link
    else
      generate_token
    end
  end

  private

  def generate_token
    token = SecureRandom.hex(5)
    Redis.current.set(token, link, ex: ttl, nx: true) ? token : generate_token
  end
end
