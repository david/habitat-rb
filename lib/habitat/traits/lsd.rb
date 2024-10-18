# frozen_string_literal: true

module Habitat
  module Traits
    class Lsd < Trait
      package "lsd"

      file "~/.config/fish/config.fish" do |env|
        if self[:alias_ls]
          append <<~EOF
            if status is-interactive
              alias ls=lsd
            end
          EOF
        end
      end
    end
  end
end
