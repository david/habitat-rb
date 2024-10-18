# frozen_string_literal: true

require_relative "./content"
require_relative "./traits"

module Habitat
  class Trait
    attr_reader :files

    def self.[](id)
      id = id.to_s
      class_name = "#{id[0].upcase}#{id[1..-1]}".gsub(/_(\w)/) { |m| m[1].upcase }
      const_get("Habitat::Traits::#{class_name}")
    rescue NameError
      Class.new(AdHoc) do
        define_method :build_packages do
          [id]
        end
      end
    end

    def self.append(string)
      Content::Suffix.new(string)
    end

    def self.file(target, content = nil, &block)
      if content && block_given?
        puts <<~EOF
        Can't define a file with both static and dynamic content. If you
        have something like this:

          file "/path/to/file", "static content" do
            "dynamic content"
          end

        either remove the do/end block or the "static content" bit, so
        you are left with this:

          file "/path/to/file", "static content"

        or this:

          file "/path/to/file" do
            "dynamic content"
          end
        EOF

        raise ""
      elsif !content && !block_given?
        raise "Missing definition for file `#{target}'"
      end

      files[target] = content || block
    end

    def self.files
      @files ||= {}
    end

    def self.packages
      @packages ||= []
    end

    def self.package(pkg)
      packages << pkg
    end

    def self.prepend(string)
      Content::Prefix.new(string)
    end

    def self.config
      @config ||= {}
    end

    def self.set(var, val)
      config[var] = val
    end

    def initialize(config)
      @config = config # Config.new(data: self.class.config.merge(config.to_h))

      @files = self.class.files
      @packages = self.class.packages
    end

    def [](var)
      @config[var]
    end

    def append(string)
      Content::Suffix.new(string)
    end

    def prepend(string)
      Content::Prefix.new(string)
    end

    def build_files(env)
      @files.
        filter_map { |path, content|
          content = instance_exec(env, &content) if content.respond_to?(:call)
          [path, Content.wrap(content)] if content
        }.
        to_h
    end

    def build_packages
      @packages
    end

    class AdHoc
      def initialize(*)
        if block_given?
          raise "#{packages.first} can't be configured with a block"
        end
      end

      def build_files(_); {}; end
    end
  end
end
