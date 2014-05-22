NlpSampleApp::Application.routes.draw do

  resources :books do
    get 'search', on: :collection
    get 'autocomplete', on: :collection
  end

  root 'home#index'

  namespace :rails_nlp do
    resources :keywords
  end



end
