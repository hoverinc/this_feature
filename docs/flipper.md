# ThisFeature - Flipper Adapter

## Installation

```ruby
gem 'this_feature-adapters-flipper
```

## Configuration

```ruby
# config/initializers/this_feature.rb
require 'this_feature'
require 'this_feature/adapters/flipper'

ThisFeature.configure do |config|
  adapter = ThisFeature::Adapters::Flipper.new
  config.adapters = [adapter]
  config.default_adapter = adapter
end
```

An existing Flipper client can be optionally passed to the initializer:

```
ThisFeature::Adapters::Flipper.new(client: my_existing_client)
```


## API

The Flipper adapter supports the public API of `ThisFeature`.

The `context` argument is supported, but not `data`.

Read the following notes as well:

- **on?** / **off?**: Under the hood, calls `flipper_id` method on the `context`, if one was given.
- **control?** / **present?**: Flipper doesn't have a concept of "control", so we just implement it as `!present?`

It is possible to support `on!` and `off!` from Flipper but that's not implemented yet.
