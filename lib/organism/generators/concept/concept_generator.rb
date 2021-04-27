module Organism
  class ConceptGenerator < Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :actions, type: :array, default: [], banner: 'action action'

    def create_concept_files
      create_present_concept
      create_create_concept
      create_update_concept
    end

    private

    def create_present_concept
      create_concept_file('present')
    end

    def create_create_concept
      create_concept_file('create')
      create_concept_spec('create')
      create_contract_file('create')
    end

    def create_update_concept
      create_concept_file('update')
      create_concept_spec('update')
      create_contract_file('update')
    end

    def singular_file_path
      model_class_path.join('/')
    end

    def create_concept_file(type)
      template(
        "#{type}.rb",
        File.join('app/concepts', singular_file_path, "#{type}.rb")
      )
    end

    def create_concept_spec(type)
      template(
        "spec/#{type}.rb",
        File.join('spec/concepts', singular_file_path, "#{type}_spec.rb")
      )
    end

    def create_contract_file(type)
      template(
        "contracts/#{type}.rb",
        File.join('app/concepts', singular_file_path, 'contracts', "#{type}.rb")
      )
    end

    def base_operation_class
      'ApplicationOperation'
    end

    def base_contract_class
      'ApplicationContract'
    end

    def nested_namespace(&block)
      content = capture(&block)
      content = wrap_model(indent(content))
      content = nest_content(content)
      concat("#{content}\n")
    end
  end
end
