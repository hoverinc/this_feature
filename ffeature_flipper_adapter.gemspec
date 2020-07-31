# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'ffeature_flipper_adapter/version'

Gem::Specification.new do |s|
  s.name          = 'ffeature_flipper_adapter'
  s.version       = FfeatureFlipperAdapter::VERSION
  s.authors       = ['Max Pleaner']
  s.email         = ['maxpleaner@gmail.com']
  s.homepage      = 'https://github.com/Max Pleaner/ffeature_flipper_adapter'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
