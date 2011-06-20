class ApplicationController < ActionController::Base
  protect_from_forgery

  # stub for content pages
  def show
    render action: 'regression', layout: false
  end

end