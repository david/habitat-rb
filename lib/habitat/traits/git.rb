# frozen_string_literal: true

module Habitat
  module Traits
    class Git < Trait
      package "git"

      file "~/.config/git/config", <<~EOF
        [diff]
          colorMoved = true

        [merge]
          conflictStyle = "diff3"

        [rerere]
          enabled = true
        EOF
    end
  end
end
