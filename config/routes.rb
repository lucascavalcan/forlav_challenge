Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :sales do
    collection do
      post :import
    end
  end
  
  resources :companies
  
  # root to: 'sales#show', id: '1'
  root to: 'welcome#index' 
end
