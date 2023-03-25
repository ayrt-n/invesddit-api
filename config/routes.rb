Rails.application.routes.draw do
  defaults format: :json do
    namespace :api do
      namespace :v1 do
        resources :communities, only: %i[index create show update] do
          resources :posts, only: :index, strategy: 'community'
          resources :text_posts, controller: 'posts', only: %i[create], type: 'TextPost'
          resources :link_posts, controller: 'posts', only: %i[create], type: 'LinkPost'
          resources :media_posts, controller: 'posts', only: %i[create], type: 'MediaPost'
          resource :memberships, only: %i[create destroy]
        end

        resources :posts, only: %i[index show update destroy] do
          resources :comments, only: %i[index create]
          resource :votes, only: %i[create destroy]
        end

        resources :comments, only: %i[update destroy] do
          resource :votes, only: %i[create destroy]
        end

        resources :accounts, only: %i[index show] do
          resources :posts, only: :index, strategy: 'account'
        end

        resource :account, only: %i[update edit] do
          get 'communities', to: 'accounts#communities'
        end

        resources :notifications, only: %i[index update]
        patch '/notifications', to: 'notifications#read_all'

        resource :search, only: :show
      end
    end
  end
end
