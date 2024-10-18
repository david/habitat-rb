# frozen_string_literal: true

module Habitat
  module Traits
    class Direnv < Trait
      package "direnv"

      file "~/.config/fish/config.fish", append(
        <<~EOF
        if status is-interactive
          direnv hook fish | source
        end
        EOF
      )
    end
  end
end
