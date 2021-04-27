require 'rails/generators'
require 'organism/generators/generator_helper'

module Organism
  module Generators
    class Base < Rails::Generators::NamedBase
      include Organism::GeneratorHelper
      include Rails::Generators::ResourceHelpers
    end
  end
end
