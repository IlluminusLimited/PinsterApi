if Rails.env.production?
  Rails.application.configure do
    config.lograge.enabled = true
    config.lograge.base_controller_class = 'ActionController::API'

    config.lograge.ignore_actions = ["HealthCheck::HealthCheckController#index"]
  end
end