# ThisFeature - Split Adapter

## Installation

```ruby
gem 'this_feature-adapters-split-io'
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

We've also added `record`, which is a helper to easily and consistently add
attributes to the `data` hash. To take advantage of this, the application must
set a `base_data_lambda` in the config. An example—
```ruby
ThisFeature.configure do |config|
  config.base_data_lambda = ->(record) do
    case record
    when Org
      {
        org_id: record.id,
        org_name: record.name
      }
    when User
      {
        org_id: record.org.id,
        org_name: record.org.name,
        user_email: record.email,
        user_id: record.id,
        user_name: record.name,
      }
    end
  end
end
```
Then `ThisFeature.flag("my-flag", record: user).on?` will automatically include
org_id, org_name, user_email, user_id, and user_name in the data attributes.
