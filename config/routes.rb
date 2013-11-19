Mercury::Engine.routes.draw do
  get '/editor(/*requested_uri)' => "mercury#edit", :as => :mercury_editor

  scope '/mercury' do
    get   ':type/:resource',        :to => "mercury#resource"
    match 'snippets/:name/options', :to => "mercury#snippet_options", :via => [:get, :post]
    match 'snippets/:name/preview', :to => "mercury#snippet_preview", :via => [:get, :post]
  end
end
