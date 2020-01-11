require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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
    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :users do
    resources :rewards, only: :index
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do

      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: [:new, :edit], shallow: true do
        resources :answers, except: [:new, :edit]
      end
    end
  end

end
