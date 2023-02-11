class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @form = ShortLinkForm.new
  end

  def generate
    @form = ShortLinkForm.new(permitted_params)

    if @form.valid?
      @token = save_in_redis
      render :index
    else
      render :index
    end
  end

  private

  def permitted_params
    params.permit(short_link_form: [:link, :short_link, :expired_at]).dig(:short_link_form)
  end

  def save_in_redis # запихнуть в сервис
    if @form.short_link.present?
      Redis.current.setnx(@form.short_link, @form.link)
      Redis.current.expire(@form.short_link, @form.expiration_seconds)
      @form.short_link
    else
      token = SecureRandom.hex(5)

      if Redis.current.setnx(token, @form.link)
        Redis.current.expire(token, @form.expiration_seconds)
        token
      else
        save_in_redis
      end
    end
  end
end
