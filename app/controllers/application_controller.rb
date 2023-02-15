class ApplicationController < ActionController::Base
  def render_404
    respond_to do |format|
      format.html { render file: 'public/404', status: 404, layout: false }
      format.xml { head 404 }
      format.js { head 404 }
      format.json { head 404 }
    end
  rescue ActionController::UnknownFormat
    render status: 404, plain: 'Not Found'
  end
end
