RSpec.describe Organism::CellsGenerator, type: :generator do
  context 'with a new module' do
    destination Organism::Generators.tmp
    arguments %w[other/some_things new create edit update show index --collections list table]

    before(:all) do
      prepare_destination
      run_generator
    end

    context 'with a new or edit action' do
      let(:cell) { 'app/cells/other/some_thing/form.rb' }
      let(:view) { 'app/cells/other/some_thing/form/show.erb' }
      let(:spec) { 'spec/cells/other/some_thing/form_spec.rb' }

      it 'creates a cell' do
        expected_cell = <<~CELL
          module Other
            class SomeThing < ApplicationRecord
              class Form < ApplicationCell
                include Forms

                def show
                  render
                end
              end
            end
          end
        CELL

        assert_file cell, expected_cell
      end

      it 'creates a form outline' do
        expected_view = <<~VIEW
          <%= simple_form_for model, as: :some_thing, url: submit_url do |f| %>
            <fieldset>
              <%= legend %>
            </fieldset>

            <%= controls(f) %>
          <% end %>
        VIEW

        assert_file view, expected_view
      end

      it 'creates a form spec' do
        expected_spec = <<~VIEW
          describe Other::SomeThing::Form, type: :cell do
            controller ApplicationController
            let(:result) { Capybara::Node::Simple.new(html) }
            let(:model) do
              Other::SomeThing::Contracts::Create.new(Other::SomeThing.new)
            end
            let(:html) do
              cell(
                described_class,
                model,
                path: {
                  submit: '#',
                  back: '#'
                }
              ).()
            end

            it 'renders the form without error' do
              expect(result).to have_xpath '//form'
            end
          end
        VIEW

        assert_file spec, expected_spec
      end
    end

    context 'with show action or list collection' do
      let(:cell) { 'app/cells/other/some_thing/cell.rb' }
      let(:show) { 'app/cells/other/some_thing/cell/show.erb' }
      let(:list) { 'app/cells/other/some_thing/cell/list.erb' }
      let(:spec) { 'spec/cells/other/some_thing/cell_spec.rb' }

      it 'creates a show cell' do
        expected_cell = <<~CELL
          module Other
            class SomeThing < ApplicationRecord
              class Cell < ApplicationCell
                def show
                  render
                end

                def list
                  render
                end

                private

                def component_style
                  'other-some-thing'
                end
              end
            end
          end
        CELL

        assert_file cell, expected_cell
      end

      it 'creates a show outline' do
        expected_view = <<~VIEW
          <article class="<%= style %>">
          </article>
        VIEW

        assert_file show, expected_view
      end

      it 'creates a list outline' do
        expected_view = <<~VIEW
          <article class="<%= style %>">
          </article>
        VIEW

        assert_file list, expected_view
      end

      it 'creates a cell spec' do
        expected_spec = <<~VIEW
          describe Other::SomeThing::Cell, type: :cell do
            controller ApplicationController
            let(:result) { Capybara::Node::Simple.new(html) }
            let(:model) do
              Other::SomeThing.new(id: 1)
            end

            context '#list' do
              let(:html) do
                cell(
                  described_class,
                  model,
                ).(:list)
              end

              it 'renders the list action without error' do
                expect(result).to have_xpath '//article'
              end
            end

            context '#show' do
              let(:html) do
                cell(
                  described_class,
                  model,
                ).(:show)
              end

              it 'renders the show action without error' do
                expect(result).to have_xpath '//article'
              end
            end
          end
        VIEW

        assert_file spec, expected_spec
      end
    end

    context 'with a list collection' do
      let(:cell) { 'app/cells/other/some_thing/list.rb' }
      let(:spec) { 'spec/cells/other/some_thing/list_spec.rb' }

      it 'creates a list cell' do
        expected_cell = <<~CELL
          module Other
            class SomeThing < ApplicationRecord
              class List < ApplicationCell
                def show
                  cell(
                    Ui::List,
                    other_some_things,
                    **list_options
                  ).()
                end

                private

                def list_options
                  {
                    actions: actions_list,
                    header: header,
                    style: style
                  }
                end

                def header
                  content_tag(:h5, 'Some things')
                end

                def component_style
                  'other-some-thing--list'
                end

                def other_some_things
                  model
                end
              end
            end
          end
        CELL

        assert_file cell, expected_cell
      end

      it 'creates a list spec' do
        expected_spec = <<~VIEW
          describe Other::SomeThing::List, type: :cell do
            controller ApplicationController
            let(:result) { Capybara::Node::Simple.new(html) }
            let(:items) do
              [Other::SomeThing.new(id: 1)]
            end
            let(:html) do
              cell(
                described_class,
                model,
              ).()
            end

            it 'renders the list without error' do
              expect(result).to have_xpath '//ul'
            end
          end
        VIEW

        assert_file spec, expected_spec
      end

    end

    context 'with a table collection' do
      let(:cell) { 'app/cells/other/some_thing/table.rb' }
      let(:spec) { 'spec/cells/other/some_thing/table_spec.rb' }

      it 'creates a table cell' do
        expected_cell = <<~CELL
          module Other
            class SomeThing < ApplicationRecord
              class Table < ApplicationCell
                def show
                  cell(
                    Ui::Table,
                    other_some_things,
                    **table_options
                  ).()
                end

                private

                def table_options
                  {
                    actions: actions_list,
                    header: header,
                    style: style
                  }
                end

                def header
                  content_tag(:h5, 'Some things')
                end

                def component_style
                  'other-some-thing--table'
                end

                def other_some_things
                  model
                end
              end
            end
          end
        CELL

        assert_file cell, expected_cell
      end

      it 'creates a table spec' do
        expected_spec = <<~VIEW
          describe Other::SomeThing::Table, type: :cell do
            controller ApplicationController
            let(:result) { Capybara::Node::Simple.new(html) }
            let(:items) do
              [Other::SomeThing.new(id: 1)]
            end
            let(:html) do
              cell(
                described_class,
                model,
              ).()
            end

            it 'renders the table without error' do
              expect(result).to have_xpath '//table'
            end
          end
        VIEW

        assert_file spec, expected_spec
      end
    end
  end
end
