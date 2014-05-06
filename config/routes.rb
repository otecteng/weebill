Weebill::Application.routes.draw do
  devise_for :users
  resources  :tb_customers

  resources :tb_trades do
    get  'import',:on=>:collection
    post  'upload',:on=>:collection

  end

  resources :site_workers do 
    post 'register',:on=>:collection
    get 'lock_worker',:on=>:member
  end
  
  resources :service_orders do
    get "new_mobile", :on=>:collection
    get "send_sms", :on=>:member
  end

  resources :sites do
    get  'import',:on=>:collection
    post  'upload',:on=>:collection
    resources :service_orders do
    end
  end

  resources :brands
  
  root :to => 'users#welcome'
  get  'site_workers/wx' => 'site_workers#wx_index'
  get  'tb_customers/wx' => 'tb_customers#wx_index'
  post 'site_workers/wx' => 'site_workers#wx_create'
  post 'tb_customers/wx' => 'tb_customers#wx_create'

end
