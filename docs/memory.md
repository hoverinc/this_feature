# ThisFeature - Memory Adapter

## Synopsis

Under the hood, the memory adapter stores data in a dictionary like so:

```ruby
{
  some_flag_name: {
    global: false,
    contexts: {
      User1: true,
      User2: false
    }
  }
}
```

Since it doesn't require actual DB lookups, it's faster, and works well for use
in test suites.

## Installation

This adapter is included with the core gem:

```ruby
gem 'this_feature'
```

## Configuration

```ruby
# config/initializers/this_feature.rb
require 'this_feature'
require 'this_feature/adapters/memory'

ThisFeature.configure do |config|
  config.test_adapter = ThisFeature::Adapters::Memory.new
  config.adapters = [config.test_adapter]
  config.default_adapter = config.test_adapter
end
```

The initializer takes an optional `context_key_method` argument. This is only relevant when using `context` -
it specifies a method name which should be called on the context object to determine its identity.
For example:

```ruby
# Say you have this method which you want to use as the "identity"
# of a context object (e.g. imagine this module is included onto User)
module FeatureFlaggable
  def this_feature_id
    "#{self.class}-#{self.id}"
  end
end

# Then you would refer to it like so in the initializer:
ThisFeature::Adapters::Memory.new(context_key_method: :this_feature_id)
```

If this option is ommitted, then the context object uses its `self` as its "identity".

**See below for example of how to use on! and off! from tests**

## API

The Memory adapter supports the public API of `ThisFeature`.

### **#on? / #off?**

If passed a `context` argument, uses the aformentioned logic
(`context_key_method`) to determine how it's handled.

Usage example of these:

```ruby
# If you have configured the in-memory adapter as the default
ThisFeature.test_adapter.on!(:flag_name, context: user) # with context
ThisFeature.test_adapter.off!(:flag_name)               # without context
```

### **#clear**

Since the memory adapter stores flags in memory, it won't automatically get cleaned up in your tests. You can use this method to reset the memory adapter state.

```ruby
ThisFeature.test_adapter.clear
```
