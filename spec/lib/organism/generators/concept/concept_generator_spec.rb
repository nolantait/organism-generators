RSpec.describe Organism::ConceptGenerator, type: :generator do
  context 'with a new module' do
    destination Organism::Generators.tmp
    arguments %w[other/some_things new create]

    before(:all) do
      prepare_destination
      run_generator
    end

    context 'with present action' do
      let(:file) { 'app/concepts/other/some_thing/present.rb' }

      it 'creates a namespaced action' do
        expected_file = <<~FILE
          module Other
            class SomeThing < ApplicationRecord
              class Present < ApplicationOperation
                step Model(Other::SomeThing, :find_by)
                step Contract::Build(constant: Other::SomeThing::Contracts::Update),
                  Output(:success) => End(:success)

                fail Model(Other::SomeThing, :new),
                  id: :build_new,
                  Output(:success) => Track(:success)
                step Contract::Build(constant: Other::SomeThing::Contracts::Create),
                  id: :build_new_contract
              end
            end
          end
        FILE

        assert_file file, expected_file
      end
    end

    context 'with create action' do
      let(:file) { 'app/concepts/other/some_thing/create.rb' }

      it 'creates a namespaced action' do
        expected_file = <<~FILE
          module Other
            class SomeThing < ApplicationRecord
              class Create < ApplicationOperation
                step Subprocess(Other::SomeThing::Present)
                step Contract::Validate(key: :some_thing)
                step Contract::Persist()
              end
            end
          end
        FILE

        assert_file file, expected_file
      end
    end

    context 'with update action' do
      let(:file) { 'app/concepts/other/some_thing/update.rb' }

      it 'creates a namespaced action' do
        expected_file = <<~FILE
          module Other
            class SomeThing < ApplicationRecord
              class Update < Create
              end
            end
          end
        FILE

        assert_file file, expected_file
      end
    end

    context 'with a create spec' do
      let(:file) { 'spec/concepts/other/some_thing/create_spec.rb' }

      it 'creates a namespaced spec' do
        class_header = /describe Other::SomeThing::Create/

        assert_file file, class_header
      end
    end

    context 'with an update spec' do
      let(:file) { 'spec/concepts/other/some_thing/update_spec.rb' }

      it 'creates a namespaced spec' do
        class_header = /describe Other::SomeThing::Update/

        assert_file file, class_header
      end
    end
  end
end
