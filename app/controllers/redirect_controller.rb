class RedirectController < ApplicationController
  def redirect
    token = params.permit(:token)[:token]
    url = Redis.current.get(token)

    if url
      redirect_to url
    else
      render_404
    end
  end
end
