# frozen_string_literal: true

require 'test_helper'

class ImagePolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create or modify images' do
    user = User.anon_user
    assert_not_permitted(user, Image, :create?)
    assert_not_permitted(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users cannot create images' do
    user = users(:sally)
    assert_not_permitted(user, Image, :create?)
  end

  test 'users cannot modify images' do
    user = users(:sally)
    assert_not_permitted(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'moderators can modify images' do
    user = users(:bob)
    assert_permit(user, Image, ANY_INSTANCE_MODIFY_ACTION)
    assert_permit(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    assert_permit(user, Image, ANY_ACTION)
    assert_permit(user, images(:texas_dragon_image_one), ANY_ACTION)
  end
end
