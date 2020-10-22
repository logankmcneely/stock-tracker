Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  resources :connections, only: [:create, :destroy]
  get 'users/my_portfolio'
  devise_for :users
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'
  get 'my_connections', to: 'users#connections'
end
