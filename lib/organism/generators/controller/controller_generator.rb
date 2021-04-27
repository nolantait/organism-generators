module Organism
  class ControllerGenerator < Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :actions, type: :array, default: [], banner: 'action action'
    class_option :model, type: :string, default: ''

    check_class_collision suffix: 'Controller'

    def create_controller_files
      template(
        'controller.rb',
        File.join('app/controllers', class_path, "#{file_name}_controller.rb")
      )
    end

    def add_routes
      return if actions.empty?

      route(
        "resources :#{file_name}, only: %i[#{actions.join(' ')}]",
        namespace: regular_class_path
      )
    end

    private

    def after_create_path
      redirect_to_resource
    end

    def after_update_path
      redirect_to_resource
    end

    def after_destroy_path
      "#{index_helper}_path"
    end

    def redirect_to_resource
      show? ? "#{singular_route_name}_path(result[:model])" : "#{index_helper}_path"
    end
  end
end
