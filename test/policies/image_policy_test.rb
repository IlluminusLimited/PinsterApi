# frozen_string_literal: true

require 'test_helper'

class ImagePolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create or modify images' do
    user = CurrentUser.new(User.anon_user)
    assert_not_permitted(user, Image, :create?)
    assert_not_permitted(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users cannot create images' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, Image, :create?)
  end

  test 'user can create profile pictures' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, Image.new(imageable: user), :create?)
  end

  test 'users can modify images they own' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, images(:sallys_favorite_collection_main_image), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users cannot modify images they dont own' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
    assert_not_permitted(user, images(:toms_face), ANY_INSTANCE_MODIFY_ACTION)
    assert_not_permitted(user, images(:toms_keepers_collection_main_image), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users cannot modify restricted properties' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    image = images(:sallys_favorite_collection_main_image)
    assert_strong_parameters(user, image, image.attributes.to_h, Image.public_attribute_names)
  end

  test 'moderators can modify images' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[update:image destroy:image]))
    assert_permit(user, Image, ANY_INSTANCE_MODIFY_ACTION)
    assert_permit(user, images(:texas_dragon_image_one), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'admins can perform any action' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[create:image update:image destroy:image]))
    assert_permit(user, Image, ANY_ACTION)
    assert_permit(user, images(:texas_dragon_image_one), ANY_ACTION)
  end
end
