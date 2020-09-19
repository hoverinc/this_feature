# ThisFeature - Memory Adapter

## Installation

This adapter is included with the core gem:

```ruby
gem 'this_feature
```

## Configuration

```ruby
# config/initializers/this_feature.rb
require 'this_feature'
require 'this_feature/adapters/memory'

ThisFeature.configure do |config|
  adapter = ThisFeature::Adapters::Memory.new
  config.adapters = [adapter]
  config.default_adapter = adapter
end
```

The initializer takes an optional `context_key_method` argument. This is only relevant when using `context` - 
it specifies a method name which should be called on the context object to determine its identity.
For example:

```
# Say you have this method which you want to use as the "identity" of a context object:
module FeatureFlaggable
  def this_feature_id
    "#{self.class}-#{self.id}"
  end
end

# Then you would refer to it like so in the initializer:
ThisFeature::Adapters::Memory.new(context_key_method: :this_feature_id)
```

If this option is ommitted, then the context object uses its `self` as its "identity".

## API

The Memory adapter supports the public API of `ThisFeature`.

The `context` argument is supported, but not `data`.

Read the following notes as well:

- **on?** / **off?**: Under the hood, calls `flipper_id` method on the `context`, if one was given.

- **control?** is not yet implemented

We also support two additional methods here that aren't present on the main adapter yet:

- **on!** / **off!**

Usage example of these:

```
# If you have configured the in-memory adapter as the default
ThisFeature.default_adapter.on!(:flag_name, context: user) # with context
ThisFeature.default_adapter.off!(:flag_name)               # without context
```
