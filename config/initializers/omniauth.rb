Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], scope: 'email, profile'
  # provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], scope: 'email, profile, https://mail.google.com/, https://www.googleapis.com/auth/gmail.modify, https://www.googleapis.com/auth/gmail.compose, https://www.googleapis.com/auth/gmail.send'
end
