class MercuryController < ActionController::Base
  include ::Mercury::Authentication

  skip_authorization_check

  protect_from_forgery

  before_filter :authenticate, :only => [:edit, :update, :create]

  layout false

  def update
    if params[:content]

      params[:content].each do |content|
        return if content.is_a? Hash
        content_data = content[1]
        c = MercuryContent.find_or_create_by_name_and_type(content[0], content_data['type'])
        snippets = content_data.delete('snippets')

        if snippets
          snippets.each do |snippet|
            snip = MercurySnippet.find_or_create_by_name(snippet[0])
            snip.update_attribute(:snippet, snippet)
          end
        end
        content_data[:settings] = content_data.delete('attributes')
        c.update_attributes(content_data)
      end
    end
    render text: "" # return for mercury
  end

  def edit
    render :text => '', :layout => 'mercury'
  end

  def resource
    render :action => "/#{params[:type]}/#{params[:resource]}"
  end

  def snippet_parameters
    snippet = MercurySnippet.find_by_name(params[:name])
    render :json => snippet.snippet
  end

  def snippet_options
    @options = params[:options] || {}
    @name = params[:name] || {}
    render :action => "/snippets/#{params[:name]}/options"
  end

  def snippet_preview
    render :action => "/snippets/#{params[:name]}/preview"
  end

  def test_page
    render :text => params
  end

  private

  def authenticate
    redirect_to "/#{params[:requested_uri]}" unless can_edit?
  end
end
