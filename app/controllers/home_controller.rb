class HomeController < ApplicationController
  before_action :authenticate_user! # для редиректа это не нужно будет

  def index
    @form = ShortLinkForm.new
  end

  def generate
    binding.pry

  end
end
