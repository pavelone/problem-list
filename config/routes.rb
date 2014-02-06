ProblemList::Application.routes.draw do
  resources :lists
  root to: 'lists#new'
end
