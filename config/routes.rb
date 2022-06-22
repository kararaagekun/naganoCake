Rails.application.routes.draw do

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

namespace :admins do
    get "/" => "adimins/homes#top"
    resources :customers, only: [:show, :index, :edit, :update]
    resources :products, except: [:destroy]
    resources :orders, only: [:show, :update]
    resources :order_products, only: [:update]
    resources :genres, only: [:create, :index, :edit, :update]
  end


# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

namespace :publics do
root to: "publics/homes#top"
get "/about" => "publics/homes#about"

resource :customers, only: [:show, :edit, :update]
get "/customers/exit" => "customers#exit"
patch "/customers/out" => "customers#out"
resources :products, only: [:show, :index]
resources :shipping_addresses, only: [:index, :edit, :create, :update, :destroy]

resources :cart_products, only: [:index, :create, :update, :destroy]
delete "/cart_products" => "publics/cart_products#destroy_all"

resources :orders, only: [:index, :show, :new, :create]
post "/orders/check" => "publics/orders#check"
get "/orders/complete" => "publics/orders#complete"
end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
