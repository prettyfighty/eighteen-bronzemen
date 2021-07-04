Rails.application.routes.draw do

  root 'missions#index'

  resources :missions do
      get :shared_mission_list, on: :collection
      member do
        get :share_with_group
        post :share_mission
        post :leave_mission
      end
  end

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

  namespace :admin, as: "otrmbklhufma" do
    resources :users
  end

  resources :groups do
    get :my_group, on: :collection
    member do
      post :join_group
      post :leave_group
      post :invite_user
    end
  end

end
