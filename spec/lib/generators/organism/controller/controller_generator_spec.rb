RSpec.describe Organism::ControllerGenerator, type: :generator do
  context 'with a new module' do
    destination Organism::Generators.tmp
    arguments %w[other/things new create edit update show index destroy]

    before(:all) do
      prepare_destination
      run_generator
    end

    let(:file) { 'app/controllers/other/things_controller.rb' }

    context 'with all actions' do
      it 'creates a view that calls a cell' do
        expected_file = <<~FILE
          module Other
            class ThingsController < ApplicationController
              before_action :set_thing, only: %i[destroy edit show update]

              def index
                @things = Other::Thing.all
              end

              def show; end

              def new
                run Other::Thing::Present
              end

              def create
                run Other::Thing::Create do |result|
                  return redirect_to(
                    other_thing_path(result[:model]),
                    notice: t('other.thing.create.success')
                  )
                end

                render :new
              end

              def edit
                run Other::Thing::Present
              end

              def update
                run Other::Thing::Update do |result|
                  return redirect_to(
                    other_thing_path(result[:model]),
                    notice: t('other.thing.update.success')
                  )
                end

                render :edit
              end

              def destroy
                @thing.destroy
                redirect_to(
                  other_things_index_path,
                  notice: t('other.thing.destroy.success')
                )
              end

              private

              def set_thing
                @thing = Other::Thing.find(params[:id])
              end
            end
          end
        FILE

        assert_file file, expected_file.chomp
      end
    end
  end
end
