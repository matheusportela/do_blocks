Gem::Specification.new do |spec|
  spec.name          = "do_blocks"
  spec.version       = "0.1.0"
  spec.summary       = %q{Useful before, after, and on error blocks for methods}
  spec.description   = %q{This gem allows classes to easily define blocks that are executed before a method run, after a method run, or when an error occurs during the method's execution.}
  spec.authors       = ["Matheus Portela"]
  spec.homepage      = "https://github.com/matheusportela/do_blocks"
  spec.license       = "MIT"
  spec.required_ruby_version = ['>= 3.0.0']
  spec.files       = Dir.glob('lib/*')

  spec.add_development_dependency "bundler", "~> 2.0"
end
