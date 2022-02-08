Rails.application.routes.draw do
  devise_for :customers, controllers: {
        sessions: 'customers/sessions',
        registrations: 'customers/registrations'
      }

  devise_for :admins, controllers: {
        sessions: 'admins/sessions',
        registrations: 'admins/registrations'
      }

  namespace :admin do
    resources :genres, only:[:index, :create, :edit, :update]
    resources :items, except:[:destroy]
    resources :customers, only:[:index, :show, :edit, :update]
    resources :orders, only:[:show, :update]
    resources :order_details, only:[:update]
    get 'top' => 'homes#top'
  end

  scope module: :public do
    get 'top' => 'homes#top'
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :items, only:[:index, :show]
    resources :customers, only:[:show, :edit, :update]
    get 'unsubscride' => 'customers#unsubscride'
    patch 'withdraw' => 'customers#withdraw'
    resources :cart_items, only:[:index, :update, :destroy, :create]
    delete 'destroy_all' => 'cart_items#destroy_all'
    resources :orders, only:[:new, :create, :index, :show]
    post 'orders/confirm' => 'orders#confirm'
    get 'thanks' => 'orders#thanks'
    resources :addresses, only:[:index, :edit, :create, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
