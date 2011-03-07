# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_protest_session',
  :secret      => '4565c8d1223456674d12ef6254452289eee1127ca0cf271e7b0928b7e241442001cb8f677ca8cf30dc1994fb6a10e97706a0a8a3d2775f5be6d2d76d537709da'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
