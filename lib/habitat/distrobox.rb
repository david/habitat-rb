# frozen_string_literal: true

module Habitat
  class Distrobox
    Box = Data.define(:id, :name, :status, :image)

    def boxes
      `distrobox-list --no-color`.
        split("\n").
        drop(1).
        # ID, NAME, STATUS, IMAGE
        map { |l| Box.new(*l.split("|").map(&:strip)) }
    end
  end
end
