require_relative 'lib/organism/generators/version'

Gem::Specification.new do |spec|
  spec.name          = 'organism-generators'
  spec.version       = Organism::Generators::VERSION
  spec.authors       = ['Nolan Tait']
  spec.email         = ['nolanjtait@gmail.com']

  spec.summary       = <<~SUMMARY
    Rails generators for quickly prototyping organisms.
  SUMMARY
  spec.description   = <<~DESCRIPTION
    Rails generators for quickly prototyping organisms.
  DESCRIPTION
  spec.homepage      = 'https://github.com/nolantait/organism-generators'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'byebug', '~> 11.1.3'
  spec.add_development_dependency 'generator_spec', '~> 0.9.4'
  spec.add_development_dependency 'rspec', '~> 3.10.0'
end
