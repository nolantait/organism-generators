require 'organism/generators/version'
require 'organism/generators/base'
require 'organism/generators/cells/cells_generator'
require 'organism/generators/concept/concept_generator'
require 'organism/generators/controller/controller_generator'
require 'organism/generators/views/views_generator'
require 'organism/generators/scaffold/scaffold_generator'

module Organism
  module Generators
    class Error < StandardError; end
    # Your code goes here...

    def self.root
      File.dirname __dir__
    end
  end
end
