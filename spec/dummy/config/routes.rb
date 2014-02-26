Rails.application.routes.draw do
  get 'mercury/test_page' => "mercury#test_page"

  mount Mercury::Engine => "/"
end
