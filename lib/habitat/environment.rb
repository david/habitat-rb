# frozen_string_literal: true

require_relative "./config"
require_relative "./trait"
require_relative "./snapshot"

module Habitat
  class Environment
    def initialize(config)
      @config = config
      @snapshot = Snapshot.new("environments/#{@config[:id]}")
    end

    def [](var)
      @config[var]
    end

    def editor
      self[:editor]
    end

    def sync
      install_files
      install_packages
    end

    private def files
      traits.each_with_object({}) { |(id, trait), acc|
        files = trait.build_files(@config)

        acc.merge!(files) { |_, a, b| a.merge(b) }
      }
    end

    private def packages
      traits.values.flat_map { |trait| trait.build_packages }
    end

    private def install_files
      files.each do |path, content|
        target_path = local_path(path)
        real_path = @snapshot.put(target_path, content)

        FileUtils.mkdir_p(File.dirname(target_path))
        FileUtils.ln_sf(real_path, target_path)
      end
    end

    private def install_packages
      system(install_command(packages))
    end

    private def traits
      self[:traits].map { |id, config| [id, Trait[id].new(config)] }.to_h
    end

    class Config < Habitat::Config
      def initialize(data = {}, templates = {}, &)
        @templates = templates

        super({traits: {}}.merge(data), &)
      end

      private def apply(*templates)
        templates.each do |t|
          template = @templates.fetch(t)

          data.merge!(template.to_h) do |_, a, b|
            case [a, b]
            in Array, Array
              a | b
            in Hash, Hash
              a.merge(b)
            else
              raise "Unknown combination: #{a.inspect} #{b.inspect}"
            end
          end
        end
      end

      private def editor(id, **opts, &)
        data[:editor] = use(id, **opts, &)
      end

      private def shell(id, **opts, &)
        data[:shell] = use(id, **opts, &)
      end

      private def use(*traits, **data, &)
        if traits.one?
          self[:traits][traits.first] = Config.new({id: traits.first}.merge(data), &)
        elsif !block_given?
          traits.each { |t| self[:traits][t] = Config.new(id: t) }
        else
          raise "Can't pass a block with multiple traits"
        end
      end
    end
  end
end
