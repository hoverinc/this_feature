require 'bundler/setup'
require 'ffeature'
require 'ostruct'
require 'database_cleaner/active_record'

require_relative 'support/test_database.rb'
require_relative 'support/schema.rb'
require_relative 'support/fake_adapter.rb'

require 'ffeature_flipper_adapter'

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
