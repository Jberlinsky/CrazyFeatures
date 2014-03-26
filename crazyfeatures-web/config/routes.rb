CrazyfeaturesWeb::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

  resources :repositories, only: [:index, :show, :edit] do
    resources :test_runs, only: [:show]
  end
  get "home/unauthenticated"
  get "home/index"
  authenticated :user do
    root to: 'repositories#index'
  end

  unauthenticated do
    root to: "home#unauthenticated", as: :unauthenticated
  end
end
