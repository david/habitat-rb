# frozen_string_literal: true

module Habitat
  class Config
    attr_reader :data

    def initialize(data = {}, &)
      @data = {}
      @data.merge!(data)

      instance_eval(&) if block_given?
    end

    def [](var)
      @data[var]
    end

    def to_h
      @data
    end

    def method_missing(var, value)
      @data[var] = value
    end
  end
end
