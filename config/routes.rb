Weebill::Application.routes.draw do
  get  'site_workers/wx' => 'site_workers#wx_index'
  get  'tb_customers/wx' => 'tb_customers#wx_index'
  post 'site_workers/wx' => 'site_workers#wx_create'
  post 'tb_customers/wx' => 'tb_customers#wx_create'
  match 'sites/add' => 'sites#add'
  resources :sites,:site_workers,:tb_customers,:tb_trades,:service_orders
  
  root :to => 'users#welcome'
end
