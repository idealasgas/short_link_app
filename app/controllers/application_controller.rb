class ApplicationController < ActionController::Base
  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end
end
