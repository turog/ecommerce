Rails.application.routes.draw do
  
  root 'storefront#all_items'

  post 'order_complete' => 'cart#order_complete'
  post 'add_to_cart' => 'cart#add_to_cart'
  get 'view_order' => 'cart#view_order'
  get 'checkout' => 'cart#checkout'

  resources :line_items
  resources :orders
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  get 'categorical' => 'storefront#items_by_category'
  get 'branding' => 'storefront#items_by_brand'
  get 'all' => 'storefront#all_items'

  # get 'storefront/all_items'
  # get 'storefront/items_by_category'
  # get 'storefront/items_by_brand'


  resources :categories
  resources :products





end
  