# frozen_string_literal: true

require 'auth_strategy'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth_strategy, '9Upy12YHRFFEStkJP9nteGFWxLZx26gmzUSnwx6OqpQ', 'PNzLmXqK94IU6NLPz-MEj2-NSNqwww8MS8lsKOKAKyY', scope: 'public write'
end
