Weebill::Application.routes.draw do
  get  'site_workers/wx/:id' => 'site_workers#wx_index'
  get  'tb_customers/wx/:id' => 'tb_customers#wx_index'
  post 'site_workers/wx/:id' => 'site_workers#wx_create'
  post 'tb_customers/wx/:id' => 'tb_customers#wx_create'

  devise_for :users
  resources  :tb_customers,:sms_logs,:sms_templates,:wx_templates
  resources :reports do
    get  'trades',:on=>:collection
  end
  resources :tb_trades do
    get  'import',:on=>:collection
    post  'upload',:on=>:collection
    get  'assign',:on=>:member
    post  'delete_all',:on=>:collection
    get  'error',:on=>:collection
  end

  resources :site_workers do 
    post 'register',:on=>:collection
    get 'lock_worker',:on=>:member
    get 'send_mail',:on=>:collection
    post 'send_mail',:on=>:collection
  end
  
  resources :service_orders do
    get "new_mobile", :on=>:collection
    get "inform", :on=>:member
    get "cancle", :on=>:member
    get "pay", :on=>:member
    get "install", :on=>:member
    get "assign", :on=>:member

    get "fill_m", :on=>:member
    post "install_m", :on=>:member
    post  'delete_all',:on=>:collection

    get "search_key_m", :on=>:collection
    post "search_key_m", :on=>:collection
    get "search_tid_m", :on=>:collection
    post "search_tid", :on=>:collection
    post "search_uid", :on=>:collection

    get "export", :on=>:collection
  end

  resources :sites do
    get  'import',:on=>:collection
    post  'upload',:on=>:collection
    post  'delete_all',:on=>:collection
    resources :service_orders do
    end
  end

  resources :brands  
  root :to => 'users#welcome'

end
