Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # users
      post 'create_user', to: 'users#create_user'
      get 'single_user/:id', to: 'users#single_user'
      get 'all_users', to: 'users#all_users'
      patch 'update_user/:id', to: 'users#update_user'
      delete 'delete_user/:id', to: 'users#delete_user'

      # login
      post 'user_login', to: 'users#user_login'

      # refresh_token
      post 'refresh_token', to: 'users#refresh_token'

      # forgot_password
      post 'forgot_password', to: 'users#forgot_password'

      # reset_password
      post 'reset_password', to: 'users#reset_password'
    end
  end
end
