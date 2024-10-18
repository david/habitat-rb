# frozen_string_literal: true

require_relative "../content"
require_relative "../trait"

module Habitat
  module Traits
    class Fish < Trait
      package "fish"

      set :ls_aliases, false

      file "~/.config/fish/config.fish" do |env|
        vi_block =
          if env[:editor][:style] == :vi
            <<~EOF
            if status is-interactive
              set fish_cursor_default block
              set fish_cursor_insert line

              fish_vi_key_bindings
            end
            EOF
          end

        alias_ls =
          if self[:ls_aliases]
            <<~EOF
            if status is-interactive
              alias ll="ls -l"
              alias la="ls -a"
              alias lla="ls -la"
            end
            EOF
          end

        <<~EOF
        /home/linuxbrew/.linuxbrew/bin/brew shellenv | source

        set -U fish_greeting ""

        #{vi_block}
        #{alias_ls}
        EOF
      end
    end
  end
end
