class Mercury::ImagesController < MercuryController

  # POST /images.json
  def create
    @image = Mercury::Image.new(params[:image])
    @image.save
    respond_to do |format|
      format.json {
        render :json => {:image => @image} 
      }
    end
  end

  # DELETE /images/1.json
  def destroy
    @image = Mercury::Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.json {
        render :json => {:image => @image} 
      }
    end
  end
  
end
