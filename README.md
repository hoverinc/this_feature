# Feature

The goal here is to replace all our feature flag calls with one to this gem. That will let us migrate the flags from one provider to another more easily.

# Todos

Add more adapters:

- Split.io
- ENV
- Mixpanel
- YAML file

## Development

The tests are a good reflection of the current development state.

Run them with `bundle exec rspec` after bundle installing.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'feature', github: 'hoverinc/feature'
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

Currently, the only available adapter is `Flipper`.

We will update this document when more are added.

To set it up, put this in an initializer file:

```ruby
Feature.set_adapters([Feature::Adapters::FlipperAdapter])
```

This `set_adapters` will internally call the `.setup` method on the `FlipperAdapter`, which performs the Flipper initialization.

Then you can call `Feature.enabled?("flag name")`.

It will iterate through the adapters until one of them returns `true`/`false`.

A context (`User` or `Org`) can be passed in the arguments to `enabled?` as well. `Feature.enabled?(:flag_name, Current.user)`
