module Organism
  module GeneratorHelper
    private

    def controller_class_name
      file_name.pluralize.camelize
    end

    def nested_namespace(&block)
      content = capture(&block)
      content = nest_content(content)
      concat(content)
    end

    def nest_content(content)
      class_path.each do |namespace|
        constant = namespace.camelize
        begin
          content = wrap_namespace(indent(content), constant.constantize)
        rescue NameError
          content = wrap_namespace(indent(content), constant)
        end
      end

      content
    end

    def wrap_model(content)
      "class #{model_class} < ApplicationRecord\n#{content}\nend"
    end

    def wrap_namespace(content, namespace)
      return "module #{namespace}\n#{content}\nend" if namespace.is_a? String

      superclass = namespace.superclass
      case superclass
      when Object
        "class #{key}\n#{content}\nend"
      else
        "class #{key} < #{superclass}\n#{content}\nend"
      end
    end

    def namespaced_model_class
      model_class_path.map!(&:camelize).join('::')
    end

    def model_class_path
      class_path + [file_name.singularize]
    end

    def singular_file_name
      file_name.singularize
    end

    def model_class
      options[:model].blank? ? file_name.singularize.camelize : options[:model]
    end

    def singular_actions
      actions.select do |action|
        %w[show destroy edit update].include?(action)
      end
    end

    def singular_actions?
      singular_actions.any?
    end

    def new?
      action?('new')
    end

    def create?
      action?('new') || action?('create')
    end

    def show?
      action?('show')
    end

    def index?
      action?('index')
    end

    def edit?
      action?('edit')
    end

    def update?
      action?('edit') || action?('update')
    end

    def destroy?
      action?('destroy')
    end

    def action?(action)
      actions.include?(action)
    end
  end
end
