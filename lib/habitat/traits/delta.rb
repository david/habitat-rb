# frozen_string_literal: true

module Habitat
  module Traits
    class Delta < Trait
      package "git-delta"

      file "~/.config/git/config", append(
        <<~EOF
        [core]
          pager = "delta"

        [delta]
          hyperlinks = true
          line-numbers = true
          navigate = true
          side-by-side = true
          true-color = "always"

        [interactive]
          diffFilter = "delta --color-only"
        EOF
      )
    end
  end
end
