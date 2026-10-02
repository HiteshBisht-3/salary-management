Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees do
        resources :salaries, only: %i[index create]
      end

      get "analytics/summary",
          to: "analytics#summary"

      get "analytics/by_department",
          to: "analytics#by_department"

      get "analytics/by_country",
          to: "analytics#by_country"
    end
  end
end