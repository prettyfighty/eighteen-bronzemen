Rails.application.routes.draw do

  root 'missions#index'

  resources :missions

  resources :users, path: "user", only: [] do
    collection do
      get :sign_up, action: 'new'
      post :sign_up, action: 'create'
    end
  end

  resources :sessions, path: "user", only: [] do
    collection do
      get :sign_in, action: "new"
      post :sign_in, action: "create"
      delete :sign_out, action: "destroy"
    end
  end

end
