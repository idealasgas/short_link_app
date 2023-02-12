class RedirectController < ApplicationController
  include Prometheus::Controller

  def redirect
    token = params.permit(:token)[:token]
    url = Redis.current.get(token)

    CLICK_LINKS_COUNTER.increment(labels: { token: token })

    if url
      redirect_to url
    else
      render_404
    end
  end
end
