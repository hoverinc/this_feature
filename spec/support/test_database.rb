ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "memory"
)

require_relative './schema.rb'