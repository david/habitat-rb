# frozen_string_literal: true

module Habitat
  module Traits
    class Zoxide < Trait
      package "zoxide"

      file "~/.config/fish/config.fish", append(
        <<~EOF
        if status is-interactive
          zoxide init fish | source
        end
        EOF
      )
    end
  end
end
