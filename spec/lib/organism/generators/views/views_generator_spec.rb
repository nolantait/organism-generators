RSpec.describe Organism::ViewsGenerator, type: :generator do
  context 'with a new module' do
    destination Organism::Generators.tmp
    arguments %w[other/some_things new create edit update show index --collections list]

    before(:all) do
      prepare_destination
      run_generator
    end

    context 'with new action' do
      let(:file) { 'app/views/other/some_things/new.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::SomeThing::Form,
            @form,
            path: {
              submit: other_some_things_path,
              back: other_some_things_path
            }
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with edit action' do
      let(:file) { 'app/views/other/some_things/edit.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::SomeThing::Form,
            @form,
            path: {
              submit: other_some_thing_path(@model),
              back: other_some_thing_path(@model)
            }
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with show action' do
      let(:file) { 'app/views/other/some_things/show.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::SomeThing::Show,
            @other_some_thing,
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with show action' do
      let(:file) { 'app/views/other/some_things/show.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::SomeThing::Show,
            @other_some_thing,
          ).() %>
        CELL

        assert_file file, cell
      end
    end

    context 'with index action' do
      let(:file) { 'app/views/other/some_things/index.html.erb' }

      it 'creates a view that calls a cell' do
        cell = <<~CELL
          <%= cell(
            Other::SomeThing::List,
            @other_some_things,
          ).() %>
        CELL

        assert_file file, cell
      end
    end
  end
end
