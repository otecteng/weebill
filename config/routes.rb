Weebill::Application.routes.draw do
  devise_for :users
  get  'sites/import' => 'sites#import'
  post  'sites/upload' => 'sites#upload'
  get  'tb_trades/import' => 'tb_trades#import'
  post  'tb_trades/upload' => 'tb_trades#upload'
  get  'site_workers/wx' => 'site_workers#wx_index'
  get  'tb_customers/wx' => 'tb_customers#wx_index'
  post 'site_workers/wx' => 'site_workers#wx_create'
  post 'tb_customers/wx' => 'tb_customers#wx_create'
  match 'sites/add' => 'sites#add'
  resources :site_workers,:tb_customers,:tb_trades
  
  resources :service_orders do
    get "new_mobile", :on=>:collection
    get "send_sms", :on=>:member
  end

  resources :sites do
    resources :service_orders
  end

  resources :brands
  
  root :to => 'users#welcome'
end
