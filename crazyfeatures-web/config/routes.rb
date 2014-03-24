CrazyfeaturesWeb::Application.routes.draw do
  get "home/index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }
  root to: 'home#index'
end
