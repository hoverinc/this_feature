# ThisFeature

The purpose of ThisFeature is to have one way to use feature flags

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'this_feature'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install this_feature
```

## Configuration

```ruby
# config/initializers/this_feature.rb
require 'this_feature'

ThisFeature.configure do |config|
  config.adapters = [ThisFeature::Adapters::Memory]
  config.default_adapter = config.adapters.first
end
```

**NOTE**: When searching for the presence of a flag, adapters are queried in order. The default adapter is the fallback adapter used when a flag isn't present in any of the adapters.


### With Flipper

```ruby
# config/initializers/this_feature.rb
require 'this_feature/adapters/flipper'

ThisFeature.configure do |config|
  config.adapters = [ThisFeature::Adapters::Flipper]
  config.default_adapter = config.adapters.first
end
```



## Usage

### Flags
```ruby
ThisFeature.flag('flag_name').on? # check if flag is turned on
ThisFeature.flag('flag_name').off? # check if flag is turned off
ThisFeature.flag('flag_name').control? # see if the adapter is using the control
ThisFeature.flag('flag_name').on! # turn on the flag
ThisFeature.flag('flag_name').off! # turn off the flag
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

## TODO: Write documentation for the adapters (creating adapters, using memory adapter, using flipper adapter)


## Development

The tests are a good reflection of the current development state.
You can run the tests with these commands in your Terminal:

```
bundle install && bundle exec rspec
```

## License

ThisFeature is released under the [MIT License](https://choosealicense.com/licenses/mit).
