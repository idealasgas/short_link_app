class HomeController < ApplicationController
  include Prometheus::Controller

  before_action :authenticate_user!

  def index
    @form = ShortLinkForm.new
  end

  def generate
    @form = ShortLinkForm.new(permitted_params)
    # лок на редис?????????????
    if @form.valid?
      @token = ::ShortLinkGenerationService.call(@form.link, @form.expired_at, @form.short_link)
      render :index
    else
      render :index
    end
  end

  def gauge
    COUNTER_EXAMPLE.increment(labels: { service: 'foo' })
    respond_to do |r|
      r.any do
        render json: {
                 message: "Success",
               }, status: 200
      end
    end
  end

  private

  def permitted_params
    params.permit(short_link_form: [:link, :short_link, :expired_at]).dig(:short_link_form)
  end
end
