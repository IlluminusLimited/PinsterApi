# frozen_string_literal: true

class CurrentUserFactory
  attr_reader :logger, :token_factory_resolver, :current_user, :user_finder

  def initialize(opts = {})
    @logger = opts[:logger] ||= Rails.logger
    @token_factory_resolver = opts[:token_factory_resolver] ||= Utilities::TokenFactoryResolver.new
    @current_user = opts[:current_user] ||= CurrentUser
  end

  def from_jwt(jwt)
    return current_user.new(User.anon_user) if jwt.nil?

    token_factory_resolver.call(jwt).to_current_user
  end
end
