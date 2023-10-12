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
  },
  some_flag_name_with_treatments: {
    treatment_contexts: {
      User1: 'treatment_name_1',
      User2: 'treatment_name_2',
      User3: 'treatment_name_3'
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
    "#{self.class}-#{id}"
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

### **#enable_treatment!**

This method is useful when you need to enable a feature flag with a treatment (or multiple treatments), and not just `"on"` and `"off"`.

Usage example of these:

```ruby
# If you have configured the in-memory adapter as the default
ThisFeature.test_adapter.enable_treatment!(:flag_name, treatment: 'treatment_name', context: user)
```
#### This method requires 3 arguments:
1. `flag_name`: String or Symbol (not a named argument)
2. `treatment`: String
3. `context`: User or Org object

Per flag name, there can only be one treatment per `context_key` (the ID of object that is provided as `context`). So multiple calls with the same `context`, but different treatment names, will be overwritten.

```ruby
ThisFeature.test_adapter.enable_treatment!('flag_a', treatment: 'treatment_1', context: user1)
ThisFeature.test_adapter.storage # => { 'flag_a' => { :treatment_contexts => { 'User1': 'treatment_1' } } }

ThisFeature.test_adapter.enable_treatment!(:flag_a, treatment: 'treatment_2', context: user1)
ThisFeature.test_adapter.storage # => { 'flag_a' => { :treatment_contexts => { 'User1': 'treatment_2' } } }
```

### **#treatment_value**

You can retrieve the flag's treatment name for a specific context.

Usage example of these:

```ruby
# If you have configured the in-memory adapter as the default
ThisFeature.test_adapter.treatment_value(:flag_name, context: user)
```

#### This method requires 2 arguments:
1. `flag_name`: String or Symbol (not a named argument)
2. `context`: User or Org object

When the Memory storage does not contain the given flag_name or if there is no provided `context`, `"control"` is returned. This is meant to mimic what SplitIO would return in the case of no configured treatment for the given `context`.
### **#clear**

Since the memory adapter stores flags in memory, it won't automatically get cleaned up in your tests. You can use this method to reset the memory adapter state.

```ruby
ThisFeature.test_adapter.clear
```
