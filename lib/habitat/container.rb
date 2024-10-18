# frozen_string_literal: true

require_relative "./environment"

module Habitat
  class Container < Environment
    protected def install_command(packages)
      brew = "/home/linuxbrew/.linuxbrew/bin/brew install #{packages.join(" ")}"

      "distrobox enter #{self[:id]} -- #{brew}"
    end

    protected def local_path(path)
      old_home = ENV["HOME"]

      ENV["HOME"] = File.expand_path(self[:root])

      File.expand_path(path)
    ensure
      ENV["HOME"] = old_home
    end
  end
end
