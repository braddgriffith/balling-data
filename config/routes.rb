BallingData::Application.routes.draw do
  resources :ticket_seeds, :only => [:new, :create]
end
