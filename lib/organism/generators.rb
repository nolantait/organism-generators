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
      File.expand_path('../', __FILE__)
    end

    def self.tmp
      File.join(root, '..', '..', 'tmp')
    end
  end
end
