class ShortLinkForm
  include ActiveModel::Validations # удалить?
  include ActiveModel::Model # удалить?
  extend ActiveModel::Naming # удалить?

  attr_accessor :link, :short_link, :expired_at

  validates :link, presence: true
  validates :short_link, length: { in: 5..10 },
                        format: { with: /\A[a-zA-Z0-9]+\z/, message: "only allows letters and digits" },
                        allow_blank: true

  validate :short_link_is_available
  validate :expired_at_is_in_future
  validate :link_is_valid

  def to_model
    self
  end

  def persisted?
    false
  end

  def expired_at_is_in_future
    if expired_at.present?
      if expired_at.to_date <= Date.today
        errors.add(:expired_at, "can't be in the past")
      end
    end
  end

  def short_link_is_available
    errors.add(:short_link, "not available") if short_link.present? && Redis.current.exists(short_link)
  end

  def link_is_valid
    uri = URI.parse(link)
    errors.add(:link, "invalid") unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  end

  def expiration_seconds
    expired_at.present? ? (expired_at.to_time - Time.current).to_i : 30.days.to_i
  end
end
