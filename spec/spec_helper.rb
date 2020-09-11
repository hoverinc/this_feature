require 'bundler/setup'
require 'this_feature'
require 'ostruct'
require 'database_cleaner/active_record'
require 'pry-byebug'

require_relative 'support/test_database.rb'
require_relative 'support/schema.rb'
require_relative 'support/fake.rb'

require 'this_feature/adapters/flipper'
require 'this_feature/adapters/split_io'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
