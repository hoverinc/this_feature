# ThisFeature - Split Adapter

## Installation

```ruby
gem 'this_feature-adapters-split-io
```

## Configuration

```ruby
# config/initializers/this_feature.rb
require 'this_feature'
require 'this_feature/adapters/split_io'

ThisFeature.configure do |config|
  adapter = ThisFeature::Adapters::SplitIo.new
  config.adapters = [adapter]
  config.default_adapter = adapter
end
```

An existing Split client can be optionally passed to the initializer:

```
ThisFeature::Adapters::SplitIo.new(client: my_existing_client)
```

## API

The SplitIo adapter supports the public API of `ThisFeature`.

Both `context` and `data` are supported.

`control` is a native Split feature, so we perform a query to Split to get this info.