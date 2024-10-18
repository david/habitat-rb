require "minitest/autorun"
require "habitat/config"

module Habitat
  class ConfigTest < Minitest::Test
    def test_set_simple_value
      assert 1, config[:opt]
    end

    def test_to_h
      assert_equal({opt: 1}, config.to_h)
    end

    private def config
      Config.new { opt 1 }
    end
  end
end
