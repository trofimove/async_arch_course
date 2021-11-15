# frozen_string_literal: true

require 'auth_strategy'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth_strategy, '9Gmn7J9MywRNqTvkcO8wMDxNynnrAju1jzOFzm_65yI', 'YErVrbIXn2k_SQjvm4SnWFV5BVnj34pZBrdRAUKLtUY', scope: 'public write'
end
