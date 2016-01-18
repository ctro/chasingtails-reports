Chasingtails::Application.routes.draw do

  devise_for :users, :path_prefix => "auth"
  resources :users

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
