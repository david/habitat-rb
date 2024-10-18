# frozen_string_literal: true

require "fileutils"

module Habitat
  module Content
    def self.wrap(value)
      if value.is_a?(Fragment) || value.is_a?(Doc) || value.is_a?(Ref)
        value
      elsif File.file?(value)
        Ref.new(value)
      elsif value.is_a?(String)
        Doc.new(main: value)
      else
        raise "Unknown content type: #{value.inspect}"
      end
    end

    class Doc
      attr_reader :main, :prefix, :suffix

      def initialize(suffix: "", main: nil, prefix: "")
        @suffix = suffix
        @prefix = prefix
        @main = main
      end

      def append(string)
        Doc.new(suffix: @suffix + string, main: @main, prefix: @prefix)
      end

      def prepend(string)
        Doc.new(suffix: @suffix, main: @main, prefix: string + @prefix)
      end

      def merge(content)
        case content
        when Doc
          Doc.new(
            suffix: @suffix + content.suffix,
            main: content.main ? content.main : @main,
            prefix: content.prefix + @prefix
          )
        else
          content.merge(self)
        end
      end

      def to_s
        "#{@prefix}#{@main}#{@suffix}"
      end

      def write(path)
        File.write(path, to_s) if @main
      end

      def ==(other)
        to_s == other.to_s
      end

      def hash
        to_s.hash
      end
    end

    class Fragment
      def append(string)
        to_doc.append(string)
      end

      def prepend(string)
        to_doc.prepend(string)
      end
    end

    class Prefix < Fragment
      def initialize(string)
        @string = string
      end

      def merge(content)
        content.prepend(@string)
      end

      def to_doc
        @to_doc ||= Doc.new(prefix: @string)
      end

      def write(_); end
    end

    class Suffix < Fragment
      def initialize(string)
        @string = string
      end

      def merge(content)
        content.append(@string)
      end

      def to_doc
        @to_doc ||= Doc.new(suffix: @string)
      end

      def write(_); end
    end

    class Ref < Fragment
      def initialize(path)
        @path = path
      end

      def merge(content)
        to_doc.merge(content)
      end

      def to_doc
        @to_doc ||= Doc.new(main: File.read(@path))
      end

      def write(path)
        FileUtils.cp(@path, path)
      end
    end
  end
end
