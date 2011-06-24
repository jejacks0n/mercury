class MercuryController < ActionController::Base
  protect_from_forgery

  def edit
    render :text => '', :layout => 'mercury'
  end

  def resource
    render :action => "/#{params[:type]}/#{params[:resource]}", :layout => false
  end

  def snippet_options
    render :action => "/snippets/#{params[:name]}_options", :layout => false
  end

  def snippet_preview
    render :action => "/snippets/#{params[:name]}", :layout => false
  end

end
