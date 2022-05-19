# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']
require ::File.expand_path('../config/environment', __FILE__)
Rails.application.eager_load!

Dir[
  'app/consumers/*.rb'
].each {|file| require_relative file }
# This lines will make Karafka print to stdout like puma or unicorn
if Rails.env.development?
  Rails.logger.extend(
    ActiveSupport::Logger.broadcast(
      ActiveSupport::Logger.new($stdout)
    )
  )
end
#------------------------------------------------------

class JsonDeserializer
  def self.call(message)
    result = params.raw_payload.nil? ? nil : ::JSON.parse(params.raw_payload)
    pp "-"*40
    pp result
    pp "-"*40
    result
  rescue
    pp message.payload
    pp "Error parsing the message"
    {}
  end
end

#------------------------------------------------------

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://127.0.0.1:9092]
    config.client_id = 'coordinator_rails'
    config.logger = Rails.logger
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  # Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # Uncomment that in order to achieve code reload in development mode
  # Be aware, that this might have some side-effects. Please refer to the wiki
  # for more details on benefits and downsides of the code reload in the
  # development mode
  #
  Karafka.monitor.subscribe(
    Karafka::CodeReloader.new(
      *Rails.application.reloaders
    )
  )
end

  KarafkaApp.consumer_groups.draw do
    consumer_group "accounting" do
      topic :accounts do
        consumer AccountConsumer
      end
      topic :"accounts-stream" do
        consumer AccountStreamConsumer
      end
      topic :"tasks-stream" do
        # deserializer JsonDeserializer
        consumer TaskStreamConsumer
      end
      topic :"tasks-lifecycle" do
        consumer TaskConsumer
        # deserializer JsonDeserializer
      end
    end
  end

Karafka.monitor.subscribe('app.initialized') do
  # Put here all the things you want to do after the Karafka framework
  # initialization
end

KarafkaApp.boot!
