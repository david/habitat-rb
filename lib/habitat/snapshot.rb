# frozen_string_literal: true

require "fileutils"

module Habitat
  class Snapshot
    HOME = "~/.local/share/habitat/snapshots"

    def initialize(id)
      @id = id
      @tag = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
    end

    def put(path, content)
      raise RelativeFileError if File.expand_path(path) != path

      files_path = File.join(snapshot_path, "files")
      real_path = File.join(files_path, path)

      if File.exist?(real_path)
        raise FileExistsError, "#{real_path} should not exist!"
      end

      FileUtils.mkdir_p(File.dirname(real_path))
      content.write(real_path)

      real_path
    end

    private def snapshot_path
      File.
        join(HOME, @id, @tag).
        then { |path| File.expand_path(path) }
    end

    private def write_content(path, content)
      raise "Content must exist" unless content && !content.strip.empty?

      if File.file?(content)
        FileUtils.cp(content, path)
      elsif content.is_a?(String)
        File.write(path, content)
      else
        raise "Unknown content type: #{content.class}"
      end
    end
  end
end
