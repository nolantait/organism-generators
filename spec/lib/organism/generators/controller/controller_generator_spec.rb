RSpec.describe Organism::ControllerGenerator, type: :generator do
  destination Organism::Generators.tmp
  arguments %w[other/some_thing new create edit update show index destroy]

  before(:all) do
    prepare_destination
    run_generator
  end

  context 'with a new module' do
    let(:file) { 'app/controllers/other/some_things_controller.rb' }

    context 'with all actions' do
      it 'creates a view that calls a cell' do
        expected_file = <<~FILE
          module Other
            class SomeThingsController < ApplicationController
              before_action :set_some_thing, only: %i[destroy edit show update]

              def index
                @some_things = Other::SomeThing.all
              end

              def show; end

              def new
                run Other::SomeThing::Present
              end

              def create
                run Other::SomeThing::Create do |result|
                  return redirect_to(
                    other_some_thing_path(result[:model]),
                    notice: t('other.some_thing.create.success')
                  )
                end

                render :new
              end

              def edit
                run Other::SomeThing::Present
              end

              def update
                run Other::SomeThing::Update do |result|
                  return redirect_to(
                    other_some_thing_path(result[:model]),
                    notice: t('other.some_thing.update.success')
                  )
                end

                render :edit
              end

              def destroy
                @some_thing.destroy
                redirect_to(
                  other_some_things_path,
                  notice: t('other.some_thing.destroy.success')
                )
              end

              private

              def set_some_thing
                @some_thing = Other::SomeThing.find(params[:id])
              end
            end
          end
        FILE

        assert_file file, expected_file.chomp
      end
    end
  end
end
