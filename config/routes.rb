AppLab::Engine.routes.draw do
  root "dashboard#index"

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # GitHub Commit Intelligence
  resources :daily_reports, only: [:index, :show, :update] do
    member do
      post :regenerate_summary
      post :mark_reviewed
    end
    resources :commit_entries, only: [:show, :update], shallow: true
  end

  # Security Scanning
  resources :security_scans, only: [:index, :show] do
    collection do
      post :trigger
    end
    resources :security_findings, only: [:show, :update], shallow: true do
      member do
        post :assign
        post :resolve
        post :mark_false_positive
      end
    end
  end

  # Best Practices Checklist
  resources :best_practice_categories, only: [:index, :show], path: "practices" do
    resources :best_practice_items, only: [:show], shallow: true, path: "items" do
      member do
        post :verify
        post :toggle
      end
    end
  end
  get "practices/score", to: "best_practice_categories#score"
  get "practices/history", to: "best_practice_categories#history"

  # Performance & Architecture Insights
  resources :insight_findings, only: [:index, :show, :update], path: "insights" do
    member do
      post :assign
      post :resolve
      post :ignore
    end
    collection do
      post :scan
      get :metrics
      get :trends
    end
  end

  # API namespace
  namespace :api do
    namespace :v1 do
      # GitHub
      get "github/commits", to: "github#commits"
      post "github/sync", to: "github#sync"
      get "github/summary/:date", to: "github#summary"
      put "github/summary/:date", to: "github#update_summary"

      # Security
      get "security/scans", to: "security#scans"
      post "security/scans/trigger", to: "security#trigger"
      get "security/findings", to: "security#findings"
      put "security/findings/:id", to: "security#update_finding"
      get "security/trends", to: "security#trends"

      # Best Practices
      get "practices/checklist", to: "practices#checklist"
      post "practices/verify/:item_id", to: "practices#verify"
      put "practices/check/:item_id", to: "practices#check"
      get "practices/score", to: "practices#score"
      get "practices/history", to: "practices#history"

      # Insights
      get "insights", to: "insights#index"
      post "insights/scan", to: "insights#scan"
      put "insights/:id", to: "insights#update"
      get "insights/metrics", to: "insights#metrics"
      get "insights/trends", to: "insights#trends"
    end
  end
end
