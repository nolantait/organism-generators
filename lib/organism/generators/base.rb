require 'rails/generators'
require 'organism/generators/generator_helper'

module Organism
  module Generators
    class Base < Rails::Generators::NamedBase
      include Organism::GeneratorHelper
    end
  end
end
