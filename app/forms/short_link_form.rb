class ShortLinkForm < OpenStruct
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :link, :short_link, :expired_at

  validates :link, presence: true # url
  validates :short_link, length: { in: 5..10 }, allow_blank: true # может быть тут еще проверить есть ли такой ключ в редисе
  validate :expired_at_is_in_future

  def to_model
    self
  end

  def to_key # ?
    id
  end

  def persisted?
    false
  end

  def expired_at_is_in_future
    if expired_at
      if expired_at.to_date <= Date.today
        errors.add(:expired_at, "can't be in the past")
      end
    end
  end
end
