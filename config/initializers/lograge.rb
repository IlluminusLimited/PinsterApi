if Rails.env.production?
  Rails.application.configure do
    config.lograge.enabled = true
    config.lograge.base_controller_class = 'ActionController::API'

    config.lograge.ignore_actions = ["HealthCheck::HealthCheckController#index"]
    config.lograge.custom_options = lambda do |event|
      exceptions = %w(controller action format id)
      {
          params: event.payload[:params].except(*exceptions)
      }
    end
  end
end