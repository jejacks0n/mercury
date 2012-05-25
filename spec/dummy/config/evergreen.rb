# The following allows us to have a nested directory structure of specs.  With
# a lot of specs this is needed.
Evergreen.configure do |config|
  config.root = Mercury::Engine.root
end

module Evergreen
  class Suite
    def specs
      Dir.glob(File.join(root, Evergreen.spec_dir, '**', '*_spec.{js,coffee,js.coffee}')).map do |path|
        Spec.new(self, path.gsub(File.join(root), ''))
      end
    end

    def templates
      Dir.glob(File.join(root, Evergreen.template_dir, '**', '*')).map do |path|
        Template.new(self, path.gsub(File.join(root), '')) unless File.directory?(path)
      end.compact
    end
  end
end

module Evergreen
  class Spec
    def initialize(suite, name)
      @suite = suite
      @name = name
      @name = "#{Evergreen.spec_dir}/#{name}" if !exist?
    end

    def name
      @name.gsub("/#{Evergreen.spec_dir}/", '')
    end
  end
end

module Evergreen
  class Template
    def name
      @name.gsub("/#{Evergreen.template_dir}/", '')
    end

    def full_path
      File.join(root, @name)
    end
  end
end
