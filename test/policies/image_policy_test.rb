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
    image = images(:texas_dragon_image_one)
    assert_permit(user, Image, ANY_INSTANCE_MODIFY_ACTION)
    assert_permit(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
    assert_strong_parameters(user, image, image.attributes.to_h, %i[description featured name])
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    image = images(:texas_dragon_image_one)
    assert_permit(user, Image, ANY_ACTION)
    assert_permit(user, image, ANY_ACTION)
    assert_strong_parameters(user, image, image.attributes.to_h, Image.public_attribute_names)
  end
end
