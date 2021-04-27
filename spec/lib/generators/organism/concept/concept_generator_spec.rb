require 'generator_spec'

describe Organism::ConceptGenerator, type: :generator do
  context 'with a new module' do
    destination Rails.root.join('tmp', 'generators')
    arguments %w[other/things new create]

    before(:all) do
      prepare_destination
      run_generator
    end

    context 'with present action' do
      let(:file) { 'app/concepts/other/thing/present.rb' }

      it 'creates a namespaced action' do
        expected_file = <<~FILE
          module Other
            class Thing < ApplicationRecord
              class Present < ApplicationOperation
                step Model(Other::Thing, :find_by)
                step Contract::Build(constant: Other::Thing::Contracts::Update),
                  Output(:success) => End(:success)

                fail Model(Other::Thing, :new),
                  id: :build_new,
                  Output(:success) => Track(:success)
                step Contract::Build(constant: Other::Thing::Contracts::Create),
                  id: :build_new_contract
              end
            end
          end
        FILE

        assert_file file, expected_file
      end
    end

    context 'with create action' do
      let(:file) { 'app/concepts/other/thing/create.rb' }

      it 'creates a namespaced action' do
        expected_file = <<~FILE
          module Other
            class Thing < ApplicationRecord
              class Create < ApplicationOperation
                step Subprocess(Other::Thing::Present)
                step Contract::Validate(key: :thing)
                step Contract::Persist()
              end
            end
          end
        FILE

        assert_file file, expected_file
      end
    end

    context 'with update action' do
      let(:file) { 'app/concepts/other/thing/update.rb' }

      it 'creates a namespaced action' do
        expected_file = <<~FILE
          module Other
            class Thing < ApplicationRecord
              class Update < Create
              end
            end
          end
        FILE

        assert_file file, expected_file
      end
    end

    context 'with a create spec' do
      let(:file) { 'spec/concepts/other/thing/create_spec.rb' }

      it 'creates a namespaced spec' do
        class_header = /describe Other::Thing::Create/

        assert_file file, class_header
      end
    end

    context 'with an update spec' do
      let(:file) { 'spec/concepts/other/thing/update_spec.rb' }

      it 'creates a namespaced spec' do
        class_header = /describe Other::Thing::Update/

        assert_file file, class_header
      end
    end
  end
end
