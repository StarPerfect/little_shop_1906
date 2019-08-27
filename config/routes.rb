Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id', to: 'reviews#create'
  get '/reviews/:review_id/edit', to: 'reviews#edit'
  patch '/reviews/:review_id', to: 'reviews#update'
  delete '/reviews/:review_id', to: "reviews#destroy"

  patch '/cart/:item_id', to: 'carts#create'
  get '/cart', to: 'carts#show'
  delete '/cart', to: 'carts#delete'
  post '/cart/:item_id', to: 'carts#delete_item'
  post '/cart/:item_id/decrease', to: 'carts#decrease'
  post '/cart/:item_id/increase', to: 'carts#increase'


  post '/orders/new', to: 'orders#new'
  get '/orders/:order_id', to: 'orders#create'
end
