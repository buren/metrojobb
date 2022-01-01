
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metrojobb/version'

Gem::Specification.new do |spec|
  spec.name          = 'metrojobb'
  spec.version       = Metrojobb::VERSION
  spec.authors       = ["Jacob Burenstam"]
  spec.email         = ["burenstam@gmail.com"]

  spec.summary       = %q{Build a feed for Metrojobb}
  spec.description   = %q{Build a feed for Metrojobb with ease.}
  spec.homepage      = 'https://github.com/buren/metrojobb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 5', '< 8'
  spec.add_dependency 'builder', '~> 3.2'

  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'bundler', '> 1.16', '< 3'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'
end
