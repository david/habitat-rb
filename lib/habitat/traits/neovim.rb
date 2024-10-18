# frozen_string_literal: true

require_relative "../trait"

module Habitat
  module Traits
    class Neovim < Trait
      package "neovim"

      set :style, :vi

      file "~/.config/fish/config.fish" do |env|
        if env[:editor][:id] == :neovim
          prepend <<~EOF
          set -gx EDITOR nvim
          set -gx VISUAL nvim
          EOF
        end
      end

      def config(content)
        if File.directory?(content)
          @files.merge!(
            Dir.
              chdir(content) { Dir["**"].filter { |f| File.file?(f) } }.
              map { |f| [File.join("~/.config/nvim", f), Content.wrap(File.join(content, f))] }.
              to_h
          ) { |_, a, b| a.merge(b) }
        end
      end
    end
  end
end
