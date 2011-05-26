class MercuryController < ActionController::Base
  protect_from_forgery

  def edit
    render :text => '', :layout => 'toolbar'
  end

  def show
    # TODO: this should eventually go away, and is only here to simplify
  end

  def resource
    render :action => "/#{params[:type]}/#{params[:resource]}", :layout => false
  end

end
