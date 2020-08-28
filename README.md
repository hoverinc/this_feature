# ThisFeature

**A common interface to interact with many feature flag providers.**

Can be used to more easily migrate among providers.

If your code uses ThisFeature,
then you can just swap out the adapter without having to do a bunch of find-and-replace.

## Installation

```ruby
gem 'this_feature'
```

## Configuration

```ruby
# config/initializers/this_feature.rb
require 'this_feature'

ThisFeature.configure do |config|
  config.adapters = [ThisFeature::Adapters::Memory.new]
  config.default_adapter = config.adapters.first
end
```

**NOTE**: When searching for the presence of a flag, adapters are queried in order. The default adapter is the fallback adapter used when a flag isn't present in any of the adapters.

## Usage

### Flags
```ruby
ThisFeature.flag('flag_name').on?      # is the flag is turned on?
ThisFeature.flag('flag_name').off?     # is the flag is turned off?
ThisFeature.flag('flag_name').control? # is the adapter is using the control?
ThisFeature.flag('flag_name').present? # is the flag set at all?
```

### Context

You can also pass a context to the flag, many feature flagging systems support this.

```ruby
ThisFeature.flag('flag_name', context: current_user).on?
```

### Data

In case context is not sufficient, you can also pass a data hash.

```ruby
ThisFeature.flag('flag_name', context: context, data: { org_id: 1 }).on?
```

## Available Adapters

- [Flipper](./docs/flipper.md)
- [Split.io](./docs/splitio.md)
- [Memory](./docs/memory.md) - **very helpful to use in tests**

## Development

The tests are a good reflection of the current development state.
You can run the tests with these commands in your Terminal:

```
bundle install && bundle exec rspec
```

To write a new adapter, check the [Guide](./docs/writing_an_adapter.md).

## License

ThisFeature is released under the [MIT License](https://choosealicense.com/licenses/mit).



