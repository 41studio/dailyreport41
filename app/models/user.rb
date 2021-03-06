# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#  access_token           :string
#  refresh_token          :string
#  expires_at             :datetime
#  full_name              :string
#  role                   :integer          default(4)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'net/http'

class User < ActiveRecord::Base
  extend Enumerize

  enumerize :role, in: {ceo: 1, manager: 2, bde: 3, web_developer: 4, web_designer: 5, ios_developer: 6}, predicates: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # relations
  has_many :projects, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :tasks, through: :reports

  # find by omniauth
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.full_name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end

    # set fresh token
    if auth.credentials.token.present? and auth.credentials.refresh_token.present?
      user.access_token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.expires_at = Time.at(auth.credentials.expires_at).to_datetime
      user.save
    end
    user
  end

  # @return [Boolean] user should be remembered when he logs in (with cookie)
  #   so he won't be asked to login again
  def remember_me
    true
  end

  # Makes a http POST request to the Google API OAuth 2.0 authorization endpoint
  # using parameters from above. Google returns JSON data that includes an access
  # token good for another 60 minutes.
  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, {
      'refresh_token' => refresh_token,
      'client_id' => ENV['GOOGLE_CLIENT_ID'],
      'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
      'grant_type' => 'refresh_token'
    })
  end

  # Requests the token from Google, parses its JSON response and
  # updates your database with the new access token and expiration date.
  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    if data["access_token"].present?
      update_attributes(access_token: data['access_token'], expires_at: Time.now + (data['expires_in'].to_i).seconds)
    else
      puts data["error_description"]
    end
  end

  # Returns true if your access token smells like spoiled milk.
  def token_expired?
    return true
    expires_at < Time.now if expires_at?
  end

  # A convenience method to return a valid access token, refreshing if necessary.
  def fresh_token
    refresh! if token_expired?
    access_token
  end

  def first_name
    full_name.try(:split).try(:first)
  end
end
