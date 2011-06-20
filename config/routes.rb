Rails.application.routes.draw do

  resources :images

  match '/edit(/*requested_uri)' => "mercury#edit"
  scope '/mercury' do
    match ':type/:resource' => "mercury#resource"
    match 'snippets/:name/options' => "mercury#snippet_options"
    match 'snippets/:name/preview' => "mercury#snippet_preview"
  end

  if defined?(Mercury::Application)
    root to: "application#show"
  end
end
