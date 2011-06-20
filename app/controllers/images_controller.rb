class Mercury::ImagesController < Mercury::MercuryController

  respond_to :json

  # POST /images.json
  def create
    @image = Image.new(params[:image])
    @image.save
    respond_with @image
  end

  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_with @image
  end

end
