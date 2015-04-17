# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'outrider/version'

Gem::Specification.new do |spec|
  spec.name          = "outrider"
  spec.version       = "0.0.1"
  spec.authors       = ["Jaap Badlands"]
  spec.email         = ["jaap@deadlysyntax.com"]

  spec.summary       = %q{Outrider Web Automation Framework provides structure and tools for writing web-automation tasks}
  spec.description   = %q{Outrider's purpose is to provide an easy-to-use programming interface and organisational structure, to create and run tasks that can automatically visit, interact with and test websites and also that process, clean and store data, and tools for statistical analysis. }
  spec.homepage      = "https://github.com/deadlysyntax/outrider"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency "bundler", "~> 1.9"
  #gem.add_development_dependency "rspec"
  spec.add_development_dependency "rake", "~> 10.0"
end
