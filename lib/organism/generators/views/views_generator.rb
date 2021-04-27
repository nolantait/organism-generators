module Organism
  class ViewsGenerator < Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :actions, type: :array, default: [], banner: 'action action'
    class_option :model, type: :string, default: ''
    class_option :collections, type: :array, default: ['list']

    def create_views
      viewable_actions.each do |action|
        create_view(action)
      end
    end

    private

    def create_view(action)
      template(
        "#{action}.rb",
        File.join('app/views', file_path, "#{action}.html.erb")
      )
    end

    def viewable_actions
      actions.select do |action|
        %w[new show index edit].include?(action)
      end
    end

    def collection_renderer_class
      options[:collections].first.camelize
    end
  end
end
