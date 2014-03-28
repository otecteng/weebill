Weebill::Application.routes.draw do
  get  'site_workers/wx' => 'site_workers#wx_index'
  get  'tb_customers/wx' => 'tb_customers#wx_index'
  post 'site_workers/wx' => 'site_workers#wx_create'
  post 'tb_customers/wx' => 'tb_customers#wx_create'
  match 'site_workers/all' => 'site_workers#all'
  resources :site_workers do
    
  end
  resources :tb_customers do
    
  end

  root :to => 'users#welcome'
end
