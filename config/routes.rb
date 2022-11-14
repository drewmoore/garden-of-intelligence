Rails.application.routes.draw do
    get "/plants", to: "plants#index"
end
