require 'erb'

class TemplatedYaml

  class << self

    def load(stream, filename=nil ,binding=nil)
      binding ||= self.send(:binding)
      string = ERB.new(stream.read).result(binding)
      YAML.load(string, filename)
    end

    def load_file(filename)
      File.open(filename, 'r:bom|utf-8') { |f| self.load f, filename }
    end
  end
  
end