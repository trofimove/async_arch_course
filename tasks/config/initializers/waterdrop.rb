require 'water_drop'
require 'water_drop/sync_producer'

WaterDrop.setup do |config|
  config.deliver = true
  config.kafka.seed_brokers = %w[kafka://localhost:9092]
end
