class SnippetsController < ActionController::Base
  protect_from_forgery

  def options
    render action: "/../mercury/snippets/#{params[:name]}_options", layout: false
  end

  def preview
    render action: "/../mercury/snippets/#{params[:name]}", layout: false
  end

end