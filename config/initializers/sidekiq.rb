require 'sidekiq'

unless Rails.env.development?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDIS_URL"], namespace: "dailyreport41_#{Rails.env}" }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDIS_URL"], namespace: "dailyreport41_#{Rails.env}" }
  end
end
