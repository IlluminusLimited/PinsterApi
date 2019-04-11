# frozen_string_literal: true

require 'test_helper'
require 'configurators/configurator'
class Configuratortest < ActiveSupport::TestCase
  def test_blows_up_without_output_hash_opts
    assert_raises(KeyError) do
      Configurator.new(dummy: :value)
    end
  end

  def test_hash_can_be_filled_with_values_returned_from_providers
    dummy_provider = DummyProvider.new
    test_hash = { dummy: '' }
    configurator = Configurator.new({ output_hash: test_hash }, dummy_provider)
    assert_equal({ dummy: 'value' }, configurator.populate_hash!)
  end
end

class DummyProvider
  def fetch_config
    { dummy: 'value' }
  end
end
