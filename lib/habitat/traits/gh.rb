# frozen_string_literal: true

module Habitat
  module Traits
    class Gh < Trait
      package "gh"

      file "~/.config/gh/config.yml", <<~EOF
        version: 1
        git_protocol: https
        prompt: enabled
        prefer_editor_prompt: disabled
        EOF

      file "~/.config/git/config", append(
        <<~EOF
        [credential "https://gist.github.com"]
          helper = !gh auth git-credential

        [credential "https://github.com"]
          helper = !gh auth git-credential
        EOF
      )
    end
  end
end
