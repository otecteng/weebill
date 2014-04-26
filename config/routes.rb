Weebill::Application.routes.draw do
  devise_for :users

  get  'site_workers/wx' => 'site_workers#wx_index'
  get  'tb_customers/wx' => 'tb_customers#wx_index'
  post 'site_workers/wx' => 'site_workers#wx_create'
  post 'tb_customers/wx' => 'tb_customers#wx_create'
  match 'sites/add' => 'sites#add'
  resources :sites,:site_workers,:tb_customers,:tb_trades

  resources :service_orders do
  	get "new_mobile", :on=>:collection
  end
  
  root :to => 'users#welcome'
end
