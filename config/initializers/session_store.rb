# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_capricorn_session',
  :secret      => '99b2b5a88ffc417ea773e2849890add0d7ccd6c78377dc859fb35e54cd118a5450e22d3960156a096a91c703831229f7c5b214de50785066ed66fc297af4dcc1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
