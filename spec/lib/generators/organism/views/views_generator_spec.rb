require 'generator_spec'

describe Organism::ViewsGenerator, type: :generator do
  context 'with a new module' do
    destination Rails.root.join('tmp', 'generators')
    arguments %w[other/things new create edit update show index --collections list]

    before(:all) do
      prepare_destination
      run_generator
    end

    context 'with new action' do
      let(:file) { 'app/views/other/things/new.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::Thing::Form,
            @form,
            path: {
              submit: other_things_path,
              back: other_things_path
            }
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with edit action' do
      let(:file) { 'app/views/other/things/edit.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::Thing::Form,
            @form,
            path: {
              submit: other_thing_path(@model),
              back: other_thing_path(@model)
            }
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with show action' do
      let(:file) { 'app/views/other/things/show.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::Thing::Show,
            @other_thing,
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with show action' do
      let(:file) { 'app/views/other/things/show.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::Thing::Show,
            @other_thing,
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with index action' do
      let(:file) { 'app/views/other/things/index.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::Thing::List,
            @other_things,
          ).() %>
        CELL

        assert_file file, cell
      end
    end
  end
end
