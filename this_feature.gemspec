lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "this_feature/version"

Gem::Specification.new do |spec|
  spec.name        = "this_feature"
  spec.version     = ThisFeature::VERSION

  contributors = {
    "Max Pleaner"    => "max.pleaner@hover.to",
    "Matt Fong"      => "matt.fong@hover.to",
    "Shane Becker"   => "shane.becker@hover.to",
    "Daniel Deutsch" => "daniel.deutsch@hover.to"
  }
  spec.authors     = contributors.keys
  spec.email       = contributors.values

  spec.summary     = "A common interface to interact with many feature flag providers"
  spec.description = spec.summary
  spec.homepage    = "https://github.com/hoverinc/this_feature"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-md"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "rubocop-thread_safety"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner-active_record"
  spec.add_development_dependency "gem-release"
end
