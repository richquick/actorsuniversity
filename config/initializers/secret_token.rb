# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
key =
  if Rails.env.production?
    ENV['SECRET_KEY_BASE']
  else
    '85a846a33889aa85f95e88ee3214ac2ba284fc6a5c390de3e904dc30424e2a4168c3e7d5d6287bbf23dd54fc88c2efa2bbcd89bb29cea96a75278ff6be32d7b8'
  end

raise unless key.present?

ActorsUniversity::Application.config.secret_key_base = key
