Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'
  post 'welcome/print_payload', to: 'welcome#print_payload'
  get  'opportunity_change', to: 'opportunity_changes#show'
  post 'opportunity_change', to: 'opportunity_changes#update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
