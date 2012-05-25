Rails.application.routes.draw do
  match 'mercury/test_page' => "mercury#test_page"

  mount Mercury::Engine => "/"
end
