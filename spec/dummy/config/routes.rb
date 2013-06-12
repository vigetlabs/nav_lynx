Dummy::Application.routes.draw do
  resources :projects
  root :to => 'dashboard#show'
end
