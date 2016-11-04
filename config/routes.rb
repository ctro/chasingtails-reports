Chasingtails::Application.routes.draw do

  devise_for :users, :path_prefix => "auth"
  resources :users do
    collection { get 'trash' }
    member { get 'put_back' }
  end

  resources :reports

  resources :clients do
    resources :dogs do
      collection do
        get 'checkboxes'
      end
    end
  end

  root :to => 'passthrough#index'

end
