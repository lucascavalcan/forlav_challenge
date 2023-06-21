Rails.application.routes.draw do
  get 'companies/index'
  get 'companies/show'
  get 'companies/new'
  get 'companies/edit'
  get 'companies/create'
  get 'companies/update'
  get 'companies/destroy'
  resources :sales do #rotas padrão de sales
    collection do
      post :import
    end
  end
  resources :companies #rotas padrão de companies


  # path route ("/") 
  root to: 'sales#show', id: '1' 
end
