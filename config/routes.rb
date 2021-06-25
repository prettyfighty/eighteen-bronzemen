Rails.application.routes.draw do

  root 'missions#index'

  resources :missions

end
