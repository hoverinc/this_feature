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
gem install feature
```

## Usage

### Currently

Currently, the only available adapter is `Flipper`.
We will update this document when more are added.

To set it up, put this in an initializer file:

```ruby
ThisFeature.set_adapters([ThisFeature::Adapters::FlipperAdapter])
```

This `set_adapters` will internally call the `.setup` method on the `FlipperAdapter`, which performs the Flipper initialization.

Then you can call `ThisFeature.enabled?("flag name")`.

It will iterate through the adapters until one of them returns `true`/`false`.

A context (`User` or `Org`) can be passed in the arguments to `enabled?` as well. `ThisFeature.enabled?(:flag_name, Current.user)`

### Planned

Create an initializer file in your Rails app:

`/config/initializers/this_feature.rb`

And set your list of adapters, _ordered by priority_. For example:

```ruby
ThisFeature.adapters = [SplitIO Flipper]
```

## Development

The tests are a good reflection of the current development state.
You can run the tests with these commands in your Terminal:

```
bundle install && bundle exec rspec
```

## License

ThisFeature is released under the [MIT License](https://choosealicense.com/licenses/mit).
