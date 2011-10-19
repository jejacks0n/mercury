class MercuryController < ActionController::Base
  protect_from_forgery

  def edit
    render :text => '', :layout => 'mercury'
  end

  def resource
    render :action => "/#{params[:type]}/#{params[:resource]}", :layout => false
  end

  def snippet_options
    render :action => "/snippets/#{params[:name]}/options", :layout => false
  end

  def snippet_preview
    render :action => "/snippets/#{params[:name]}/preview", :layout => false
  end

  def test_page
    render :text => params
  end

end
