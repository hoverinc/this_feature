# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

require 'this_feature/version'

Gem::Specification.new do |spec|
  spec.name    = 'this_feature-adapters-flipper'
  spec.version = ThisFeature::VERSION

  spec.authors  = ['Max Pleaner', 'Matt Fong']
  spec.email    = ['maxpleaner@gmail.com', 'matthewjf@gmail.com']
  spec.homepage = 'http://hover.to'

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.licenses    = ['MIT']
  spec.summary     = "A ThisFeature adapter to Flipper"
  spec.description = ''

  spec.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  spec.platform      = Gem::Platform::RUBY
  spec.require_paths = ['lib']

  s.add_runtime_dependency "flipper"
  s.add_runtime_dependency "flipper-active_record"
  s.add_runtime_dependency "this_feature"
end







# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

require 'this_feature/version'

Gem::Specification.new do |s|
  s.name          = 'this_feature-adapters-flipper'
  s.version       = ThisFeature::VERSION
  s.authors       = ['Max Pleaner']
  s.email         = ['maxpleaner@gmail.com']
  s.homepage      = 'http://hover.to'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

end
