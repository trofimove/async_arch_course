# frozen_string_literal: true

require 'auth_strategy'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth_strategy, 'Xc38JBKslhFck8rkOJzfLUTwyPTsXVu3nIDMpmCwssI', 'iAKG45HvZIe2Iu5f7JfbfpjLRLGg1KECiSlubZAhKiU', scope: 'public write'
end
