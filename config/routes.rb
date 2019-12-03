Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :like, :dislike
      delete :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, only: [:create, :update, :destroy] do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :users do
    resources :rewards, only: :index
  end

  root to: 'questions#index'
end
