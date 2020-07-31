# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

require 'ffeature/version'

Gem::Specification.new do |s|
  s.name          = 'ffeature-adapters-flipper'
  s.version       = FFeature::VERSION
  s.authors       = ['Max Pleaner']
  s.email         = ['maxpleaner@gmail.com']
  s.homepage      = 'http://hover.to'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.add_runtime_dependency "flipper", "~> 0.16"
  s.add_runtime_dependency "flipper-active_record", "~> 0.16"
end
