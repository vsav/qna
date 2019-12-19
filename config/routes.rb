Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks',
                                             confirmations: 'oauth_confirmations'}

  concern :votable do
    member do
      post :like, :dislike
      delete :unvote
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: [:create, :update, :destroy] do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :users do
    resources :rewards, only: :index
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
