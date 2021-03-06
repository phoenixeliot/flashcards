Rails.application.routes.draw do
  root to: 'subjects#index'

  resource :user, except: [:destroy] do
    resources :subjects, except: [:index]
  end
  resources :subjects do
    resources :flashcards, except: [:index]
    member do
      get :contributors
    end
  end
  # resources :flashcards, only: [:index]
  resource :session, only: [:new, :create, :destroy]

end
