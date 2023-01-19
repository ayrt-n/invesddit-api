Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :communities, only: %i[index create show update] do
        resources :posts, only: %i[create]
      end

      resources :posts, only: %i[index update destroy] do
        resources :comments, only: %i[create]
      end

      resources :comments, only: %i[update show delete] do
        resource :comments, only: %i[create]
      end
    end
  end
end
