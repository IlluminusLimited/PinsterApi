# frozen_string_literal: true

module TokenHelper
  ISS = "http://localhost:3000"
  AUD = ISS
  def self.token(sub, permissions = [])
    payload = {
      "iss": ISS,
      "sub": sub,
      "aud": [AUD],
      "iat": (Time.now.in_time_zone - 1.minute).to_i,
      "exp": (Time.now.in_time_zone + 20.minutes).to_i,
      "scope": "openid profile email",
      "permissions": permissions
    }

    JWT.encode payload, nil, 'none'
  end

  def self.for_user(user, permissions = [])
    token(user.external_user_id, permissions)
  end

  def self.admin_permissions
    [
      "create:assortment",
      "create:collectable_collection",
      "create:image",
      "create:pin",
      "destroy:assortment",
      "destroy:collectable_collection",
      "destroy:collection",
      "destroy:image",
      "destroy:pin",
      "destroy:user",
      "index:user",
      "show:collectable_collection",
      "show:collection",
      "update:assortment",
      "update:collectable_collection",
      "update:collection",
      "update:image",
      "update:pin",
      "update:user"
    ]
  end
end
