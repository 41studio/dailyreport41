require 'sidekiq'

unless Rails.env.development?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISCLOUD_URL"] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISCLOUD_URL"] }
  end
end
