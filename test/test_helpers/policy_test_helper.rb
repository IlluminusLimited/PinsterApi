# frozen_string_literal: true

module PolicyTestHelper
  ANY_ACTION = %i[index? show? create? update? destroy?].freeze
  ANY_VIEW_ACTION = %i[index? show?].freeze
  ANY_INSTANCE_ACTION = %i[show? update? destroy?].freeze
  ANY_INSTANCE_MODIFY_ACTION = %i[update? destroy?].freeze

  def current_user(token)
    CurrentUserFactory.new(token_verifier: token_verifier).from_token(token)
  end

  def token_verifier
    lambda do |token|
      JWT.decode(token, nil,
                 false, # Verify the signature of this token
                 algorithm: 'none',
                 iss: TokenHelper::ISS + '/',
                 verify_iss: true,
                 aud: TokenHelper::AUD,
                 verify_aud: true)
    end
  end
end
