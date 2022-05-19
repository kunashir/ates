require 'water_drop'
require 'water_drop/sync_producer'
module WaterDrop
  class BatchSyncProducer < BaseProducer

    def self.call(messages, options)
      attempts_count ||= 0
      attempts_count += 1

      validate!(options)
      return unless WaterDrop.config.deliver

      messages.each { |message| DeliveryBoy.produce(message, **options) }
      DeliveryBoy.deliver_messages
    rescue Kafka::Error => e
      graceful_attempt?(attempts_count, messages, options, e) ? retry : raise(e) # тут я еще не уверен что именно делать, но наверно так бы и оставил
    end
  end
end

WaterDrop.setup do |config|
  config.deliver = true
  config.kafka.seed_brokers = ['kafka://localhost:9092']
end
