ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'memory'
)

class FlipperFeature < ActiveRecord::Base; end
class FlipperGate < ActiveRecord::Base; end
