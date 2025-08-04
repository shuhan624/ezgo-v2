Rails.application.routes.draw do
  default_url_options Rails.application.config.action_mailer.default_url_options

  # 前台
  constraints subdomain: /^(?!admin)/ do
    scope "(:locale)", locale: /en/ do
      root 'pages#index'

      draw(:old_path_redirects)

      # 新聞
      get '/news', to: 'pages#news', as: :articles
      get '/news/:article_category', to: "articles#index", as: :cate_articles
      get '/news/:article_category/:id', to: "articles#show", as: :article
      get '/preview/news/:article_category/:id', to: "articles#preview", as: :preview_article
   

      # 常見問題
      # get "/faqs", to: "faqs#index", as: :faqs
      # get "/faqs/:faq_category", to: "faqs#index", as: :cate_faqs

      # 聯絡我們
      get '/contact', to: 'contact#new', as: :contact_us
      post '/contact', to: 'contact#create', as: :contact_us_create

      # 下載專區
      # get 'downloads', to: "downloads#index", as: :downloads

      # 檔案下載位置
      get '/file/:id', to: "documents#show", as: :document

      # 靜態頁面
      %w(about privacy terms thanks global_immigration international_schools country countryIntroduction newsDetail schoolsDetail contactUs thanks).each do |action|
        get action.dasherize, to: "pages##{action}", param: :slug
      end

      # 會員相關
      # get '/user/profile', to: 'user#profile', as: :user_profile
      # get '/user/profile/edit', to: 'user#edit', as: :edit_profile
      # put '/user/profile', to: 'user#update'
      # get '/user/password/edit', to: 'user#edit_password', as: :edit_my_password
      # put '/user/password',      to: 'user#update_password', as: :update_my_password
    end

    scope "(:locale)", locale: /en/ do
      # 自訂頁面
      get '/:id', to: 'pages#show', as: :custom_page
    end
  end

  # 後台
  constraints subdomain: /^admin/ do
    devise_for :admin, path: '',
      skip: %i[registrations],
      controllers: {
        sessions: 'devise/admins/sessions'
      },
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
      }

    authenticated :admin do
      root to: 'admin/passthrough#index', as: :admin_root
    end

    # custom devise routes
    devise_scope :admin do
      root to: 'devise/admins/sessions#new', as: :admin_login
      get 'admin/edit' => 'devise/registrations#edit', as: 'edit_admin_registration'
      put 'admin' => 'devise/registrations#update', as: 'admin_registration'
    end

    namespace :admin, path: '/' do
      get '/dashboard', to: 'dashboard#index', as: :dashboard
      get '/marketing', to: 'dashboard#marketing', as: :marketing
      resources :users do
        member do
          get :message
          post :push_message
        end
      end

      resources :articles do
        post :copy, on: :member
      end

      resources :contacts, except: %i[new create]
      resources :tags, only: %i[index]
      resources :products do
        collection do
          patch :sort
          patch :figures_sort
        end
      end

      # 301轉址
      resources :redirect_rules do
        collection do
          post :import
          patch :sort
        end
      end

      resources :menus do
        patch :sort, on: :member
      end

      concern :sortable do
        patch :sort, on: :collection
      end

      resources :admins, :custom_pages, :milestones, :roles
      resources :settings, :documents, :article_categories, :home_slides, :faqs, :faq_categories, :partners, :downloads, :download_categories, concerns: [:sortable]
    end
  end

  get '/robots.:format' => 'pages#robots'
end
