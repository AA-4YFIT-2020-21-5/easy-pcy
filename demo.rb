# Example: ActiveRecord
class CreateUserTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.references :role, foreign_key: true

      # ...
    end
  end
end

class User < ApplicationRecord
  belongs_to :role, optional: true

  def verified?
    !role.nil?
  end

  # ...
end

user = User.find_by_email(email)

# Example: ActionPack
Rails.application.routes.draw do
  root 'home#index'

  get 'datenschutz', to: 'home#datenschutz'
  get 'impressum', to: 'home#impressum'

  post 'login', to: 'account#login'
  post 'register', to: 'account#register'
  post 'logout', to: 'account#logout'

  # ...
end

class AccountController < ApplicationController
  def login
    # ...
  end

  def register
    # ...
  end

  def logout
    # ...
  end
end
