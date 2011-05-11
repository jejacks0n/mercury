class CarmentaController < ActionController::Base
  protect_from_forgery

  def edit
    render :text => '', :layout => 'toolbar'
  end

  def show
  end

  def palette
    render :partial => "palette_#{params[:palette]}", :layout => false
  end

  def select
    render :partial => "select_#{params[:select]}", :layout => false
  end

  def panel
    render :partial => "panel_#{params[:panel]}", :layout => false
  end

  def modal
    render :partial => "modal_#{params[:modal]}", :layout => false
  end

end
