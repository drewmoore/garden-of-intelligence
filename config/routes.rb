Rails.application.routes.draw do
    root "plants#index"

    get "/plants", to: "plants#index"
end
