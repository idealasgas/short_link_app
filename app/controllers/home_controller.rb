class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @form = ShortLinkForm.new
  end

  def generate
    @form = ShortLinkForm.new(permitted_params)

    if @form.valid?
      @token = ::ShortLinkGenerationService.call(@form.link, @form.expired_at, @form.short_link)
      render :index
    else
      render :index
    end
  end

  private

  def permitted_params
    params.permit(short_link_form: [:link, :short_link, :expired_at]).dig(:short_link_form)
  end
end
