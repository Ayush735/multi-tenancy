class Subdomain
  def self.matches?(request)
    case request.subdomain
    when 'www', '', nil
      false
    else
      true
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  root 'home#welcome'
  constraints Subdomain do
    resources :projects
    resources :config, only:[:new, :index, :create]
  end
end
