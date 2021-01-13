# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebot#callback'
end
