# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      patch "best", on: :member
    end
  end

  resources :attachment, only: :destroy
  resources :awards, only: :index
end
