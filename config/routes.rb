ActorsUniversity::Application.routes.draw do
  namespace :admin do
  end

  resources :followings

  resources :guesses

  resources :exam_sittings

  post '/rate' => 'rater#create', :as => 'rate'
  get "/five_hundred" => "errors#five_hundred"

  get "admin/resource_file_from/:lesson_token" => "admin/resource_files#show"

  namespace :admin do
    resource :report_lesson_completion
    resources :lesson_archivements, only: [:update, :destroy]

    resource :dashboard, only: [:show] do
      get :show
    end

    #e.g. assign/exam/2/to/course
    get "assign/:assignee_type/:assignee_id/to/:assign_to_type" =>
    "education_assignments#new", as: :assign_to

    #e.g. assign/exam/1/to/course/2
    post "assign/:assignee_type/:assignee_id/to/:assign_to_type" =>
    "education_assignments#create", as: :create_assignment

    #e.g. unassign/user/1/from/course/2
    delete "unassign/:assignee_type/:assignee_id/from/:unassign_from_type/:unassign_from_id" =>
    "education_assignments#destroy", as: :unassign_from

    resources :resource_files, only: [:show, :edit, :create, :update, :destroy]
    resources :role_usages, only: [:create, :destroy]

    resources :exam_finalizations, only: [:create]
    resources :groups

    resources :tags

    resources :lessons

    resources :courses

    resources :exams do
      resources :questions, only: ["new", "edit", "create", "update", "destroy"]
    end

    resources :users
  end


  resource :oembed, only: [:show]

  get "oembed/:url" => "oembeds#show"

  namespace :user do
    resources :tags, only: [:index, :update]
  end

  resource :dashboard, only: [:show] do
    get :show
    get :analytics
  end

  resources :self_assignments, only: [:create, :destroy]

  post "sign_me_up_for/:assign_to_type/:assign_to_id" => "self_assignments#create"
  post "unassign_me_from/:assign_to_type/:assign_to_id" => "self_assignments#destroy"

  root to: "dashboards#show"

  devise_for :users
  resources :users, only: [:edit, :show, :update]
  resources :courses, only: [:index, :show]
  resources :comments, only: [:create]

  resources :lessons, only: [:index, :show] do
    resources :lesson_completions, only: [:create]
  end

  resources :groups, only: [:index, :show]

  resources :exams, only: [:index, :show] do
    resources :exam_sittings, only: [:new, :show, :create]
  end

  resources :exam_sittings do
    resources :questions do
      resources :question_responses, only: [:index, :new, :create, :update]
    end
  end

  resources :searches, only: [:index]

  get "me" => "users#show"
  get "me/edit" => "users#edit"
end
