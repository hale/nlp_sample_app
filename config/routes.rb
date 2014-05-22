NlpSampleApp::Application.routes.draw do

  devise_for :users
  resources :books do
    get 'search', on: :collection
    get 'autocomplete', on: :collection
  end

  root 'home#index'

  namespace :rails_nlp do
    resources :keywords
  end



end
