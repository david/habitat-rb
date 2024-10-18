require "minitest/autorun"

require "habitat/config"
require "habitat/content"
require "habitat/trait"

module Habitat
  module Traits
    class Abc < Trait
      CONFIG = <<~EOF
        opt = 1
        EOF

      file "~/.config/abc/config", CONFIG

      file "~/.config/abc/config.d" do |env|
        <<~EOF
          #{env[:opt_name]} = #{env[:opt_value]}
        EOF
      end
    end
  end

  class TraitTest < Minitest::Test
    def test_access
      assert_instance_of Traits::Abc, trait
    end

    def test_ad_hoc
      unknown = Trait[:unknown].new(nil)

      assert_kind_of Trait::AdHoc, unknown
      assert_equal ["unknown"], unknown.build_packages
    end

    def test_file_building
      config = Config.new(opt_name: "opt-2", opt_value: 2)

      assert_equal(
        {
          "~/.config/abc/config" => Content.wrap(Traits::Abc::CONFIG),
          "~/.config/abc/config.d" => Content.wrap(
            <<~EOF
            opt-2 = 2
            EOF
          )
        },
        trait.build_files(config)
      )
    end

    private def trait
      Trait[:abc].new(nil)
    end
  end
end
