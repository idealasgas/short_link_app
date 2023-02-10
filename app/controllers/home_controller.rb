class HomeController < ApplicationController
  before_action :authenticate_user! # для редиректа это не нужно будет

  def index
    @form = ShortLinkForm.new
  end

  def generate
    @form = ShortLinkForm.new(permitted_params)
    binding.pry
    if @form.valid?
      # тут вся логика с редисом
    else
      render :index # тут подумать как показывать ошибки))
    end
  end

  private

  def permitted_params
    params.permit(:link, :short_link, :expired_at)
  end
end
