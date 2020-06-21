# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :down
      post :up
      post :cancel_vote
    end
  end

  resources :questions do
    resources :answers, shallow: true, concerns: :votable do
      patch "best", on: :member
    end
  end

  resources :attachment, only: :destroy
  resources :awards, only: :index
end
