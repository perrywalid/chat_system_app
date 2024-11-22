Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :applications, param: :token, only: %i[index show create] do
    resources :chats, param: :number, only: %i[index show create] do
      resources :messages, only: %i[index show create search] do
        collection do
          get 'search'
        end
      end
    end
  end
end
