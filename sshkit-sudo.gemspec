# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sshkit/sudo/version'

Gem::Specification.new do |spec|
  spec.name          = "sshkit-sudo"
  spec.version       = SSHKit::Sudo::VERSION
  spec.authors       = ["Kentaro Imai"]
  spec.email         = ["kentaroi@gmail.com"]
  spec.summary       = %q{SSHKit extension, for sudo operation with password input.}
  spec.description   = %q{SSHKit extension, for sudo operation with password input.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "sshkit", "~> 1.8"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
