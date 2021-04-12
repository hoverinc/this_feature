# ThisFeature

**A common interface to interact with many feature flag providers.**

ThisFeature can be used to more easily migrate from one feature flag service to another

If your code uses ThisFeature,
then you can just swap out the vendor adapter without needing to do a bunch of find-and-replace in your codebase
from one vendor's class/method signature to the another's.

## Installation

Add ThisFeature to your `Gemfile`:

```ruby
# Gemfile
gem 'this_feature'
```

Then from your Rails app's root directory:

```sh
bundle install
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

**NOTE**: When searching for the presence of a flag, adapters are queried in order. The default adapter is the fallback adapter used when a flag isn't present in any of the adapters.

## Usage

### Flags

```ruby
ThisFeature.flag('flag_name').on?      # is the flag is turned on?
ThisFeature.flag('flag_name').off?     # is the flag is turned off?
ThisFeature.flag('flag_name').control? # is the adapter using the control?
ThisFeature.flag('flag_name').present? # is the flag set at all?
ThisFeature.default_adapter            # access the default adapter directly if needed
```

### Context

You can also pass a `context` to the flag, many feature flagging systems support this.

```ruby
ThisFeature.flag('flag_name', context: current_user).on?
```

### Data

In case `context` is not sufficient, you can also pass a `data` hash.

```ruby
ThisFeature.flag('flag_name', context: context, data: { org_id: 1 }).on?
```

## Available Adapters

These adapters do behave slightly differently, so make sure to read the following docs:

- [Flipper adapter](./docs/flipper.md)
- [Split.io adapter](./docs/splitio.md)
- [Memory adapter](./docs/memory.md) - **designed for use in tests**

## Development

The tests are a good reflection of the current development state.
You can run the tests with these commands in your Terminal:

```
bundle install && bundle exec rspec
```

To write a new adapter, check the [Guide](./docs/writing_an_adapter.md).

## License

ThisFeature is released under the [MIT License](https://choosealicense.com/licenses/mit).



