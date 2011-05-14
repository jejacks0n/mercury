class CarmentaController < ActionController::Base
  protect_from_forgery

  def edit
    render :text => '', :layout => 'toolbar'
  end

  def show

  end

  def resource
    render :action => "/#{params[:type]}/#{params[:resource]}", :layout => false
  end

end
