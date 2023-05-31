$:.unshift File.expand_path('../lib', __FILE__)

require 'this_feature/version'

Gem::Specification.new do |spec|
  spec.name    = 'this_feature-adapters-split_io'
  spec.version = ThisFeature::VERSION

  spec.required_ruby_version = '>= 3.2'

  spec.authors  = ['Max Pleaner', 'Matt Fong']
  spec.email    = ['maxpleaner@gmail.com', 'matthewjf@gmail.com']
  spec.homepage = 'http://hover.to'

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.licenses    = ['MIT']
  spec.summary     = "A ThisFeature adapter to Split.io"
  spec.description = ''

  spec.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  spec.platform      = Gem::Platform::RUBY
  spec.require_paths = ['lib']

  spec.add_runtime_dependency "splitclient-rb"
  spec.add_runtime_dependency "this_feature"
end
