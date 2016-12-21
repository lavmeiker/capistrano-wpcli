# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/wpcli/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-wpcli"
  spec.version       = Capistrano::Wpcli::VERSION
  spec.authors       = ["Juancito Arias", "Jeremy Zahner"]
  spec.email         = ["trasgofurioso@gmail.com"]
  spec.summary       = %q{Simple Capistrano wrapper around WP-CLI}
  spec.description   = %q{Capistrano tasks for managing Wordpress}
  spec.homepage      = "https://github.com/lavmeiker/capistrano-wpcli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '~> 3.6'
  spec.add_dependency 'sshkit', '~> 1.11'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 11.2"

end
