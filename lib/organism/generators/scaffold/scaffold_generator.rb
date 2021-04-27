module Organism
  class ScaffoldGenerator < Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_scaffold
      generate 'organism:controller', file_name, *args
      generate 'organism:cells', file_name, *args
      generate 'organism:views', file_name, *args
      generate 'organism:concept', file_name, *args
    end
  end
end
