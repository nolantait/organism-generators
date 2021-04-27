module Organism
  class CellsGenerator < Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :actions, type: :array, default: [], banner: 'action action'
    class_option :model, type: :string, default: ''
    class_option :collections, type: :array, default: ['list']

    def create_cells
      cells.each do |cell|
        create_cell(cell)
        create_cell_spec(cell) if %w[cell form list table].include?(cell)

        next if cell == 'list'
        next if cell == 'table'

        create_cell_view(cell)

        next unless cell == 'cell'
        next unless cells.include?('list')

        create_cell_view(cell, 'list')
      end
    end

    private

    def create_cell_view(type, view = 'show')
      template(
        "#{type}/#{view}.rb",
        File.join('app/cells', singular_file_path, "#{type}/#{view}.erb")
      )
    end

    def create_cell(type)
      template(
        "#{type}/cell.rb",
        File.join('app/cells', singular_file_path, "#{type}.rb")
      )
    end

    def create_cell_spec(type)
      template(
        "#{type}/spec.rb",
        File.join('spec/cells', singular_file_path, "#{type}_spec.rb")
      )
    end

    def singular_file_path
      model_class_path.join('/')
    end

    def cell_actions
      [].tap do |array|
        array << 'list' if list?
        array << 'show' if show?
      end
    end

    def cells
      [].tap do |array|
        array << 'form' if form?
        array << 'cell' if cell?
        array << 'list' if list?
        array << 'table' if table?
      end
    end

    def form?
      new? || edit?
    end

    def list?
      collections.include?('list')
    end

    def table?
      collections.include?('table')
    end

    def cell?
      list? || table? || show?
    end

    def base_cell_class
      'ApplicationCell'
    end

    def form_helper_class
      'Forms'
    end

    def collections
      options[:collections]
    end

    def nested_namespace(&block)
      content = capture(&block)
      content = wrap_model(indent(content))
      content = nest_content(content)
      concat("#{content}\n")
    end

    def cell_component_style
      singular_table_name.gsub('_', '-')
    end

    def list_component_style
      "#{cell_component_style}--list"
    end

    def table_component_style
      "#{cell_component_style}--table"
    end
  end
end
