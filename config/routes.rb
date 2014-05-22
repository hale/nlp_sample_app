NlpSampleApp::Application.routes.draw do

  resources :books do
    get 'search', on: :collection
    get 'autocomplete', on: :collection
  end

  root 'home#index'




end
