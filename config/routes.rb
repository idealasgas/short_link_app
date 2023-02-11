Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  post '/generate', to: 'home#generate'
  get '/:token', to: 'redirect#redirect', as: :redirect, constraints: { token: /[A-Za-z0-9]{5,10}/ }
  get 'test_gauge', to: 'home#gauge'
end
