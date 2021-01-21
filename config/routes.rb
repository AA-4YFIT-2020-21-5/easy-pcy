Rails.application.routes.draw do
  root 'home#index'

  get 'datenschutz', to: 'home#datenschutz'
  get 'impressum', to: 'home#impressum'

  post 'login', to: 'account#login'
  post 'register', to: 'account#register'
  post 'logout', to: 'account#logout'

  get 'kurs', to: 'kurs#index'
  get 'kurs/fortschritt'
  post 'kurs/reset', to: 'kurs#reset'
  get 'kurs/:kurs', to: 'kurs#kurs'
  get 'kurs/:kurs/:kapitel', to: 'kurs#kapitel'
  get 'kurs/:kurs/:kapitel/edit', to: 'kurs#kapitel'
  get 'kurs/:kurs/:kapitel/quiz', to: 'kurs#quiz'
  post 'kurs/:kurs/:kapitel/quiz', to: 'kurs#answer'

  scope 'forum' do
    resources :posts, except: %i[index edit], shallow: true do
      post 'vote', on: :member
      resources :comments, except: %i[index edit show new], shallow: true do
        post 'vote', on: :member
        resources :replies, except: %i[index edit show new], shallow: true do
          post 'vote', on: :member
        end
      end
    end
  end
  get 'forum', to: 'forum#index'
  post 'forum/reset', to: 'forum#reset'

  get 'profile', to: 'account#profile'
  get 'profile/:user', to: 'account#profile'
  post 'profile/edit', to: 'account#edit'
  post 'account/settings', to: 'account#settings'
  post 'account/password', to: 'account#change_password'

  # get 'show', to: 'exception#show'
  # error pages
  %w[404 422 500 503].each do |code|
    get code, :to => "exception#show", :code => code
  end
end
