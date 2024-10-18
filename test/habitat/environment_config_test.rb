require "minitest/autorun"
require "habitat/environment"
require "habitat/trait"

module Habitat
  module Traits
    class Def < Trait
    end

    class Ghi < Trait
    end
  end

  class EnvironmentConfigTest < Minitest::Test
    def test_set
      assert 1, config[:opt]
    end

    private def config
      @config ||=
        begin
          templates = {t: Environment::Config.new { use :def }}

          Environment::Config.new({}, templates) {
            apply :t
            use :ghi

            opt 1
          }
        end
    end
  end
end
