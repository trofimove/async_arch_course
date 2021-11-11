# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']

require ::File.expand_path('../config/environment', __FILE__)
Rails.application.eager_load!

Rails.logger.extend(
  ActiveSupport::Logger.broadcast(
    ActiveSupport::Logger.new($stdout)
  )
)

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = %w[kafka://localhost:9092]
    config.client_id = 'tasks'
    config.logger = Rails.logger
    config.backend = :inline
  end

  Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)

  consumer_groups.draw do
    topic 'accounts-stream' do
      consumer Consumers::AccountChanges
    end

    topic 'accounts' do
      consumer Consumers::AccountChanges
    end
  end
end

KarafkaApp.boot!
