Rails.application.routes.draw do
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  scope '/ruby' do
    get "share/show"
    get "pages/index"
    get 'pages/index'
    root 'pages#index'
    get 'share/show', to: 'share#show', as: 'share'
    post '/upload_image', to: 'share#upload_image'
  #  post '/upload_image', to: 'share#upload_image'
    resources :posts
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

      # Health check 路由
      get "up" => "rails/health#show", as: :rails_health_check

      # PWA 路由
      get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
   end  
end
