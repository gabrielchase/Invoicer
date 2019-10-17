Rails.application.routes.draw do
  devise_for :users

  namespace :api do 
    namespace :v1, defaults: { format: :json } do 
      scope ':account_id' do 
        resources :contacts, only: [:index]
        
        resources :organizations, only: [:index, :create, :show, :update] do 
          resources :contacts, only: [:index, :create, :update, :destroy]
        end 
      end 

      resources :accounts, only: [:index, :create, :update] 
      resources :users, only: [:index, :create] 
      get 'users/confirm', to: 'users#confirm_user'
      resource :sessions, only: [:create, :show, :destroy]
    end 
  end 
end
