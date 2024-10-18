# frozen_string_literal: true

module Habitat
  module Traits
    class Atuin < Trait
      package "atuin"

      file "~/.config/atuin/config.toml" do |env|
        keymap_mode = env[:editor][:style] == :vi ? "vim-insert" : "emacs"

        <<~EOF
        enter_accept = true
        keymap_cursor = { \
          emacs = "steady-block", \
          vim_insert = "steady-bar", \
          vim_normal = "steady-block" \
        }
        keymap_mode = "#{keymap_mode}"

        [sync]
        records = true
        EOF
      end

      file "~/.config/fish/config.fish", append(
        <<~EOF
        if status is-interactive
          atuin init fish | source
        end
        EOF
      )
    end
  end
end
