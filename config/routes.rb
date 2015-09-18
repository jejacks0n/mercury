Mercury::Engine.routes.draw do
  # mercury custom implementation

  # put this line into your locale scope if you are using yoursite.com/de/content
  #
  # scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
  #   get '/editor(/*requested_uri)' => "mercury#edit", :as => :mercury_editor
  # end

  get '/editor(/*requested_uri)' => "mercury#edit", :as => :mercury_editor

  scope '/mercury' do
    put 'update', to: 'mercury#update', as: :mercury_update
    resources :images, to: 'mercury_images', :only => [:create, :destroy]
    get ':type/:resource', to: "mercury#resource"
    match 'snippets/:name/options', to: "mercury#snippet_options", :via => [:get, :post]
    match 'snippets/:name/preview', to: "mercury#snippet_preview", :via => [:get, :post]
    match 'snippets/:name/parameters', to: "mercury#snippet_parameters", :via => [:get, :post]
  end
  # end of mercury
end
