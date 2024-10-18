# frozen_string_literal: true

require_relative "./environment"
require_relative "./container"

module Habitat
  class Blueprint
    attr_reader :environments, :templates

    def initialize(str)
      @templates = {}
      @environments = []

      instance_eval(str)
    end

    def template(id, &)
      @templates[id] = Environment::Config.new(&)
    end

    def container(id, &)
      @environments << Environment::Config.new({id:}, @templates, &)
    end

    def environments
      @environments.map { |e| Container.new(e) }
    end
  end
end
