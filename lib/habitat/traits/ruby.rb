# frozen_string_literal: true

module Habitat
  module Traits
    class Ruby < Trait
      package "ruby"
      package "gcc@11"

      file "~/.config/fish/config.fish", append(
        <<~EOF
          fish_add_path --prepend --path /home/linuxbrew/.linuxbrew/lib/ruby/gems/3.3.0/bin
          EOF
      )
    end
  end
end
